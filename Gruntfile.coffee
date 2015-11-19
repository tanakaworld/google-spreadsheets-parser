module.exports = (grunt)->
  grunt.initConfig
    coffee:
      dist:
        options:
          bare: true
          join: true
        files:
          'dist/googleSpreadsheetsParser.js': [
            'src/googleSpreadsheetsUtil.coffee'
            'src/googleSpreadsheetsParser.coffee'
          ]

    karma:
      unit:
        configFile: 'karma.conf.coffee'

    http:
      sampleDataBasic:
        options:
          url: "https://spreadsheets.google.com/feeds/worksheets/1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I/public/basic?alt=json"
        dest: 'spec/fixtures/sampleDataBasic.json'
      sampleDataFeed:
        options:
          url: "https://spreadsheets.google.com/feeds/cells/1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I/od6/public/values?alt=json"
        dest: 'spec/fixtures/sampleDataFeed.json'

    'closure-compiler':
      publish:
        js: 'dist/googleSpreadsheetsParser.js'
        jsOutputFile: 'dist/googleSpreadsheetsParser.min.js'
        noreport: true
        options:
          compilation_level: 'SIMPLE_OPTIMIZATIONS'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-http'
  grunt.loadNpmTasks 'grunt-closure-compiler'

  grunt.registerTask 'spec', ['http', 'karma']
  grunt.registerTask 'publish', ['coffee:dist', 'closure-compiler:publish']
