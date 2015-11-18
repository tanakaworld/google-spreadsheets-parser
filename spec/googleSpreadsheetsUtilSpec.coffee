#require 'jasmine-collection-matchers'

describe GoogleSpreadsheetsUtil, ->
  beforeAll ->
    @publishedUrl = "https://docs.google.com/spreadsheets/d/1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I/pubhtml"
    @key = "1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I"
    @worksheetId = "od6"
    @util = new GoogleSpreadsheetsUtil()

  describe '.extractKey', ->
    describe 'published url is valid', ->
      it 'should got key', ->
        expect(@util.extractKey(@publishedUrl)).toEqual(@key)

    describe 'published url is invalid', ->
      it 'should got null', ->
        expect(@util.extractKey("https://invalid-url.com")).toBeNull()

  describe '.getWorksheetId', ->
    beforeEach ->
      jasmine.Ajax.install()
    afterEach ->
      jasmine.Ajax.uninstall()

    describe 'Spreadsheet is found', ->
      beforeEach ->
        mockedSampleDataBasicJson = window.__fixtures__['spec/fixtures/sampleDataBasic']

        requestUrl = "https://spreadsheets.google.com/feeds/worksheets/#{@key}/public/basic?alt=json"
        jasmine.Ajax.stubRequest(requestUrl).andReturn
          status: 200
          responseText: JSON.stringify(mockedSampleDataBasicJson)
      it 'should got worksheetId', ->
        expect(@util.getWorksheetId(@key)).toEqual(@worksheetId)

    describe 'Spreadsheet is not found', ->
      beforeEach ->
        requestUrl = "https://spreadsheets.google.com/feeds/worksheets/#{@key}/public/basic?alt=json"
        jasmine.Ajax.stubRequest(requestUrl).andReturn
          status: 404
      it 'should got null', ->
        expect(@util.getWorksheetId(@key)).toBeNull()

  describe '.getFeeds', ->
    beforeEach ->
      jasmine.Ajax.install()
    afterEach ->
      jasmine.Ajax.uninstall()

    describe 'Spreadsheet is found', ->
      beforeEach ->
        mockedSampleDataFeedJson = window.__fixtures__['spec/fixtures/sampleDataFeed']

        requestUrl = "https://spreadsheets.google.com/feeds/cells/#{@key}/#{@worksheetId}/public/values?alt=json"
        jasmine.Ajax.stubRequest(requestUrl).andReturn
          status: 200
          responseText: JSON.stringify(mockedSampleDataFeedJson)
      it 'should got feeds', ->
        expect(@util.getFeeds(@key, @worksheetId)).not.toBeNull()

    describe 'Spreadsheet is not found', ->
      beforeEach ->
        requestUrl = "https://spreadsheets.google.com/feeds/cells/#{@key}/#{@worksheetId}/public/values?alt=json"
        jasmine.Ajax.stubRequest(requestUrl).andReturn
          status: 404
      it 'should got feeds', ->
        expect(@util.getFeeds(@key, @worksheetId)).toBeNull()

  describe '.makeTitle', ->
    beforeEach ->
      @feedEntry = window.__fixtures__['spec/fixtures/sampleDataFeed'].feed.entry

    describe 'DataFeed is valid', ->
      it 'should got titles array', ->
        titles = @util.makeTitle(@feedEntry)
        expect(titles).toHaveSameItems(["ID", "Name", "Age"])

    describe 'DataFeed is invalid', ->
      it 'should got empty array', ->
        titles = @util.makeTitle({})
        expect(titles.length).toBe(0)

  describe '.makeContents', ->
    beforeEach ->
      @feedEntry = window.__fixtures__['spec/fixtures/sampleDataFeed'].feed.entry

    describe 'DataFeed is valid', ->
      it 'should got contents 2d array', ->
        contents = @util.makeContents(@feedEntry)
        expected = [
          ['1', 'Mike', '24']
          ['2', 'Chris', '28']
          ['3', 'Doug', '34']
          ['4', 'Vlade', '21']
          ['5', 'Peja', '37']
        ]
        expect(contents).toHaveSameItems(expected)

    describe 'DataFeed is invalid', ->
      it 'should got empty array', ->
        contents = @util.makeContents({})
        expect(contents).toHaveSameItems([])
