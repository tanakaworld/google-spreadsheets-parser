class GoogleSpreadsheetsParser

  constructor: (publishedUrl, hasTitle = false) ->
    key = _extractKey(publishedUrl)
    mtd = _getWorksheetId(key)
    feeds = _getFeeds(key, mtd)


    feedEntry = feeds.feed.entry

    @titles = _makeTitle(feedEntry) if hasTitle

    columnCount = feedEntry.pop().gs$cell.col

    @contents = _makeContents(feedEntry, Number(columnCount))


  _extractKey = (publishedUrl) ->
    matched = publishedUrl.match(/https:\/\/docs.google.com\/spreadsheets\/d\/(.+)\/pubhtml/)
    return null if matched.length isnt 2
    return matched[1]

  _getWorksheetId = (key) ->
    url = "https://spreadsheets.google.com/feeds/worksheets/#{key}/public/basic?alt=json"
    xhr = new XMLHttpRequest()
    xhr.open("GET", url, false)
    xhr.send()

    matched = []
    if xhr.status is 200
      basicInfo = JSON.parse(xhr.responseText)
      matched = basicInfo.feed.entry[0].id.$t.match(/https:\/\/spreadsheets.google.com\/feeds\/worksheets\/.+\/public\/basic\/(.+)/)

    return null if matched.length isnt 2
    return matched[1]

  _getFeeds = (key, workSheetId) ->
    url = "https://spreadsheets.google.com/feeds/cells/#{key}/#{workSheetId}/public/values?alt=json"

    xhr = new XMLHttpRequest()
    xhr.open("GET", url, false)
    xhr.send()

    feeds = null

    if xhr.status is 200
      feeds = JSON.parse(xhr.responseText)

    return feeds

  _makeTitle = (feedEntry) ->
    titles = []

    for obj in feedEntry
      cell = obj.gs$cell

      if Number(cell.row) is 1
        titles.push(cell.$t)
      else
        return titles

  _makeContents = (feedEntry, columnCount) ->
    contents = []

    rowNumber = 0

    for obj in feedEntry
      cell = obj.gs$cell

      if Number(cell.row) isnt 1
        if cell.row isnt rowNumber
          rowNumber = cell.row
          row = []

        row.push(cell.$t)

        if Number(cell.col) is columnCount
          contents.push(row)
          row = []

    return contents