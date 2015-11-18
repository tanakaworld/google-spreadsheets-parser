module.exports = (grunt)->
  grunt.initConfig({
    coffee:
      dist:
        options:
          bare: true
        files:
          'dist/googleSpreadsheetsParser.js': 'src/googleSpreadsheetsParser.coffee'
  })

  grunt.loadNpmTasks 'grunt-contrib-coffee'