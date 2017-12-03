var seleniumServer = require('selenium-server')
var phantomjs = require('phantomjs-prebuilt')
var nightwatchCucumber = require('nightwatch-cucumber')

// Handles the runner, location of feature files and step definitions,
// and closing of nightwatch
var nightwatchCucumberConf = {
    runner: 'nightwatch',
    featureFiles: 'features',
    stepDefinitions: 'step_definitions',
    closeSession: 'afterFeature'
}


module.exports = {
    // Loads nightwatch-cucumber configuration into main nightwatch.js conf
    src_folders: [nightwatchCucumber(nightwatchCucumberConf)],
    custom_commands_path: '',
    custom_assertions_path: '',
    page_objects_path: '',
    live_output: false,
    disable_colors: false,


    // Sets configuration for Selenium Server
    selenium : {
      start_process : true,
      server_path : "./bin/selenium-server-standalone-3.8.1.jar",
      log_path : "",
      port : 4444,
      cli_args : {
        "webdriver.chrome.driver" : "./bin/chromedriver"
      }
    },


    // Sets config options for different testing environments defined by the user
    test_settings : {
    default : {
      launch_url : "http://localhost",
      selenium_port  : 4444,
      selenium_host  : "localhost",
      desiredCapabilities: {
        browserName: "chrome",
        javascriptEnabled: true,
        acceptSslCerts: true
      }
    }
  }


}
