var GoogleSpreadsheetsParser, GoogleSpreadsheetsUtil, XMLHttpRequest;

if (!XMLHttpRequest) {
  XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
}

GoogleSpreadsheetsUtil = (function() {
  function GoogleSpreadsheetsUtil() {}

  GoogleSpreadsheetsUtil.prototype.extractKey = function(publishedUrl) {
    var matched;
    matched = publishedUrl.match(/https:\/\/docs.google.com\/spreadsheets\/d\/(.+)\/pubhtml/);
    if (matched === null || matched.length !== 2) {
      return null;
    }
    return matched[1];
  };

  GoogleSpreadsheetsUtil.prototype.getWorksheetId = function(key, sheetTitle) {
    var basicInfo, e, i, matched, ref, url, xhr;
    url = "https://spreadsheets.google.com/feeds/worksheets/" + key + "/public/basic?alt=json";
    xhr = new XMLHttpRequest();
    xhr.open("GET", url, false);
    xhr.send();
    matched = [];
    if (xhr.status === 200) {
      basicInfo = JSON.parse(xhr.responseText);
      if (sheetTitle) {
        ref = basicInfo.feed.entry;
        for (i in ref) {
          e = ref[i];
          if (e.title.$t === sheetTitle) {
            matched = e.id.$t.match(/https:\/\/spreadsheets.google.com\/feeds\/worksheets\/.+\/public\/basic\/(.+)/);
            break;
          }
        }
      } else {
        matched = basicInfo.feed.entry[0].id.$t.match(/https:\/\/spreadsheets.google.com\/feeds\/worksheets\/.+\/public\/basic\/(.+)/);
      }
    }
    if (matched === null || matched.length !== 2) {
      return null;
    }
    return matched[1];
  };

  GoogleSpreadsheetsUtil.prototype.getFeeds = function(key, workSheetId) {
    var feeds, url, xhr;
    url = "https://spreadsheets.google.com/feeds/cells/" + key + "/" + workSheetId + "/public/values?alt=json";
    xhr = new XMLHttpRequest();
    xhr.open("GET", url, false);
    xhr.send();
    feeds = null;
    if (xhr.status === 200) {
      feeds = JSON.parse(xhr.responseText);
    }
    return feeds;
  };

  GoogleSpreadsheetsUtil.prototype.makeTitle = function(feedEntry) {
    var cell, j, len, obj, titles;
    titles = [];
    for (j = 0, len = feedEntry.length; j < len; j++) {
      obj = feedEntry[j];
      cell = obj.gs$cell;
      if (cell === null) {
        return titles;
      }
      if (Number(cell.row) === 1) {
        titles.push(cell.$t);
      } else {
        return titles;
      }
    }
    return titles;
  };

  GoogleSpreadsheetsUtil.prototype.makeContents = function(feedEntry) {
    var cell, columnCount, contents, j, len, obj, row, rowNumber;
    contents = [];
    if (!(feedEntry.length >= 1 && feedEntry[0].gs$cell)) {
      return contents;
    }
    columnCount = Number(feedEntry[feedEntry.length - 1].gs$cell.col);
    rowNumber = 0;
    for (j = 0, len = feedEntry.length; j < len; j++) {
      obj = feedEntry[j];
      cell = obj.gs$cell;
      if (Number(cell.row) !== 1) {
        if (cell.row !== rowNumber) {
          rowNumber = cell.row;
          row = [];
        }
        row.push(cell.$t);
        if (Number(cell.col) === columnCount) {
          contents.push(row);
          row = [];
        }
      }
    }
    return contents;
  };

  return GoogleSpreadsheetsUtil;

})();

GoogleSpreadsheetsParser = (function() {
  function GoogleSpreadsheetsParser(publishedUrl, option) {
    var _util, feedEntry, feeds, hasTitle, key, mtd, sheetTitle;
    sheetTitle = option.sheetTitle || null;
    hasTitle = option.hasTitle || true;
    _util = new GoogleSpreadsheetsUtil();
    key = _util.extractKey(publishedUrl);
    mtd = _util.getWorksheetId(key, sheetTitle);
    feeds = _util.getFeeds(key, mtd);
    feedEntry = feeds.feed.entry;
    if (hasTitle) {
      this.titles = _util.makeTitle(feedEntry);
    }
    this.contents = _util.makeContents(feedEntry);
  }

  GoogleSpreadsheetsParser.prototype.toJson = function() {
    var result;
    result = this.contents.map((function(_this) {
      return function(content) {
        var j, len, ref, row, title, titleIndex;
        row = {};
        ref = _this.titles;
        for (titleIndex = j = 0, len = ref.length; j < len; titleIndex = ++j) {
          title = ref[titleIndex];
          row[title] = content[titleIndex];
        }
        return row;
      };
    })(this));
    return JSON.stringify(result);
  };

  return GoogleSpreadsheetsParser;

})();
