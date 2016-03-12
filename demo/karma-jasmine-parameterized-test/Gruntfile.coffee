module.exports = (grunt)->
  TEST_VERSION = 'v001'

  grunt.initConfig
    karma:
      unit:
        configFile: 'karma.conf.coffee'

  grunt.loadNpmTasks 'grunt-karma'

  grunt.registerTask 'spec', ['karma']
