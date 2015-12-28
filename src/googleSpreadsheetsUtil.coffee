class GoogleSpreadsheetsUtil

  extractKey: (publishedUrl) ->
    matched = publishedUrl.match(/https:\/\/docs.google.com\/spreadsheets\/d\/(.+)\/pubhtml/)
    return null if matched is null or matched.length isnt 2
    return matched[1]

  getWorksheetId: (key, sheetTitle) ->
    url = "https://spreadsheets.google.com/feeds/worksheets/#{key}/public/basic?alt=json"
    xhr = new XMLHttpRequest()
    xhr.open("GET", url, false)
    xhr.send()

    matched = []
    if xhr.status is 200
      basicInfo = JSON.parse(xhr.responseText)
      if sheetTitle
        for i, e of basicInfo.feed.entry
          if e.title.$t is sheetTitle
            matched = e.id.$t.match(/https:\/\/spreadsheets.google.com\/feeds\/worksheets\/.+\/public\/basic\/(.+)/)
            break
      else
        matched = basicInfo.feed.entry[0].id.$t.match(/https:\/\/spreadsheets.google.com\/feeds\/worksheets\/.+\/public\/basic\/(.+)/)

    return null if matched is null or matched.length isnt 2
    return matched[1]

  getFeeds: (key, workSheetId) ->
    url = "https://spreadsheets.google.com/feeds/cells/#{key}/#{workSheetId}/public/values?alt=json"

    xhr = new XMLHttpRequest()
    xhr.open("GET", url, false)
    xhr.send()

    feeds = null

    if xhr.status is 200
      feeds = JSON.parse(xhr.responseText)

    return feeds

  makeTitle: (feedEntry) ->
    titles = []

    for obj in feedEntry
      cell = obj.gs$cell

      if cell is null
        return titles

      if Number(cell.row) is 1
        titles.push(cell.$t)
      else
        return titles

    return titles

  makeContents: (feedEntry) ->
    contents = []

    unless feedEntry.length >= 1 and feedEntry[0].gs$cell
      return contents

    columnCount = Number(feedEntry[feedEntry.length - 1].gs$cell.col)

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
