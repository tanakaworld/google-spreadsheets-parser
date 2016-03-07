#require 'jasmine-collection-matchers'

describe GoogleSpreadsheetsParser, ->
  beforeAll ->
    @publishedUrl = "https://docs.google.com/spreadsheets/d/1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I/pubhtml"
    @key = "1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I"
    @firstWorksheetId = "od6"

  describe '.toJson', ->
    beforeEach ->
      jasmine.Ajax.install()
    afterEach ->
      jasmine.Ajax.uninstall()

    describe 'should got json', ->
      beforeEach ->
        # mock for basic
        mockedSampleDataBasicJson = window.__fixtures__['spec/fixtures/sampleDataBasic']
        requestUrl = "https://spreadsheets.google.com/feeds/worksheets/#{@key}/public/basic?alt=json"
        jasmine.Ajax.stubRequest(requestUrl).andReturn
          status: 200
          responseText: JSON.stringify(mockedSampleDataBasicJson)

        # mock for feed
        mockedSampleDataFeedJson = window.__fixtures__['spec/fixtures/sampleDataFeed']
        requestUrl = "https://spreadsheets.google.com/feeds/cells/#{@key}/#{@firstWorksheetId}/public/values?alt=json"
        jasmine.Ajax.stubRequest(requestUrl).andReturn
          status: 200
          responseText: JSON.stringify(mockedSampleDataFeedJson)

      it 'should got feeds', ->
        gss = new GoogleSpreadsheetsParser(@publishedUrl, {sheetTitle: 'Sample', hasTitle: true})
        expect(gss.toJson()).toBe('[{"ID":"1","Name":"Mike","Age":"24"},{"ID":"2","Name":"Chris","Age":"28"},{"ID":"3","Name":"Doug","Age":"34"},{"ID":"4","Name":"Vlade","Age":"21"},{"ID":"5","Name":"Peja","Age":"37"}]')
