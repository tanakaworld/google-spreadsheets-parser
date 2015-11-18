var GoogleSpreadsheetsParser, GoogleSpreadsheetsUtil;

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

  GoogleSpreadsheetsUtil.prototype.getWorksheetId = function(key) {
    var basicInfo, matched, url, xhr;
    url = "https://spreadsheets.google.com/feeds/worksheets/" + key + "/public/basic?alt=json";
    xhr = new XMLHttpRequest();
    xhr.open("GET", url, false);
    xhr.send();
    matched = [];
    if (xhr.status === 200) {
      basicInfo = JSON.parse(xhr.responseText);
      matched = basicInfo.feed.entry[0].id.$t.match(/https:\/\/spreadsheets.google.com\/feeds\/worksheets\/.+\/public\/basic\/(.+)/);
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
    var cell, i, len, obj, titles;
    titles = [];
    for (i = 0, len = feedEntry.length; i < len; i++) {
      obj = feedEntry[i];
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
    var cell, columnCount, contents, i, len, obj, row, rowNumber;
    contents = [];
    if (!(feedEntry.length >= 1 && feedEntry[0].gs$cell)) {
      return contents;
    }
    columnCount = Number(feedEntry[feedEntry.length - 1].gs$cell.col);
    rowNumber = 0;
    for (i = 0, len = feedEntry.length; i < len; i++) {
      obj = feedEntry[i];
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
  function GoogleSpreadsheetsParser(publishedUrl, hasTitle) {
    var _util, feedEntry, feeds, key, mtd;
    if (hasTitle == null) {
      hasTitle = false;
    }
    _util = new GoogleSpreadsheetsUtil();
    key = _util.extractKey(publishedUrl);
    mtd = _util.getWorksheetId(key);
    feeds = _util.getFeeds(key, mtd);
    feedEntry = feeds.feed.entry;
    if (hasTitle) {
      this.titles = _util.makeTitle(feedEntry);
    }
    this.contents = _util.makeContents(feedEntry);
  }

  return GoogleSpreadsheetsParser;

})();
