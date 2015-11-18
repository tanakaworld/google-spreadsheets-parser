module.exports = (grunt)->
  grunt.initConfig({
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
  })

  grunt.loadNpmTasks 'grunt-contrib-coffee'