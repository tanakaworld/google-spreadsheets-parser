var GoogleSpreadsheetsParser;

GoogleSpreadsheetsParser = (function() {
  var _extractKey, _getFeeds, _getWorksheetId, _makeContents, _makeTitle;

  function GoogleSpreadsheetsParser(publishedUrl, hasTitle) {
    var columnCount, feedEntry, feeds, key, mtd;
    if (hasTitle == null) {
      hasTitle = false;
    }
    key = _extractKey(publishedUrl);
    mtd = _getWorksheetId(key);
    feeds = _getFeeds(key, mtd);
    feedEntry = feeds.feed.entry;
    if (hasTitle) {
      this.titles = _makeTitle(feedEntry);
    }
    columnCount = feedEntry.pop().gs$cell.col;
    this.contents = _makeContents(feedEntry, Number(columnCount));
  }

  _extractKey = function(publishedUrl) {
    var matched;
    matched = publishedUrl.match(/https:\/\/docs.google.com\/spreadsheets\/d\/(.+)\/pubhtml/);
    if (matched.length !== 2) {
      return null;
    }
    return matched[1];
  };

  _getWorksheetId = function(key) {
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
    if (matched.length !== 2) {
      return null;
    }
    return matched[1];
  };

  _getFeeds = function(key, workSheetId) {
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

  _makeTitle = function(feedEntry) {
    var cell, i, len, obj, titles;
    titles = [];
    for (i = 0, len = feedEntry.length; i < len; i++) {
      obj = feedEntry[i];
      cell = obj.gs$cell;
      if (Number(cell.row) === 1) {
        titles.push(cell.$t);
      } else {
        return titles;
      }
    }
  };

  _makeContents = function(feedEntry, columnCount) {
    var cell, contents, i, len, obj, row, rowNumber;
    contents = [];
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

  return GoogleSpreadsheetsParser;

})();