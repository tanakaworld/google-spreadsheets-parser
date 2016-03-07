class GoogleSpreadsheetsParser

  constructor: (publishedUrl, option) ->
    sheetTitle = option.sheetTitle || null
    hasTitle = option.hasTitle || true

    _util = new GoogleSpreadsheetsUtil()

    key = _util.extractKey(publishedUrl)
    mtd = _util.getWorksheetId(key, sheetTitle)
    feeds = _util.getFeeds(key, mtd)

    feedEntry = feeds.feed.entry

    @titles = _util.makeTitle(feedEntry) if hasTitle
    @contents = _util.makeContents(feedEntry)

  toJson: ->
    result = @contents.map((content) =>
      row = {}
      for title, titleIndex in @titles
        row[title] = content[titleIndex]
      row
    )
    JSON.stringify(result)
