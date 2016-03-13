module.exports = (config) ->
  config.set

    basePath: ''

    frameworks: ['jasmine']

    files: [
      'node_modules/google-spreadsheets-parser/dist/googleSpreadsheetsParser.js'
      'src/**/*.coffee'
      'spec/**/*Spec.coffee'
    ]

    exclude: [
    ]

    preprocessors: {
      '**/*.coffee': ['coffee']
    }

    reporters: ['progress']

    port: 9876

    colors: true

    logLevel: config.LOG_INFO

    autoWatch: true

    browsers: ['PhantomJS']

    singleRun: true
