exports.config = {
  runner: 'local',
  execArgv: ['--inspect'],
  specs: [ './test/specs/dev.spec.js' ],
  maxInstances: 1,

  capabilities: {
    mobile: {
      path: '/wd/hub',
      port: 4723,
      capabilities: {
        platformName: 'ios',
        platformVersion: '13.5',
        deviceName: 'iPhone Simulator',
        app: '/Users/seanwarman/Library/Developer/Xcode/DerivedData/careplanner-gdhtffpejyhmxzdzkekrihmwchew/Build/Products/Debug-iphonesimulator/careplanner.app',
        automationName: 'XCUITest',
        newCommandTimeout: 0,
        // autoAcceptAlerts: true,
        noReset: true,
        resetApp: false,
        connectHardwareKeyboard: true,
        simulatorPasteboardAutomaticSync: 'on',
      },
    },
    chrome: {
      capabilities: {
        browserName: 'chrome',
      },
    },
  },

  logLevel: 'error', // Level of logging verbosity: trace | debug | info | warn | error | silent

  bail: 1,
  // If you only want to run your tests until a specific amount of tests have failed use
  // bail (default is 0 - don't bail, run all tests).

  // Default timeout for all waitFor* commands.
  waitforTimeout: 100000,
  //
  // Default timeout in milliseconds for request
  // if browser driver or grid doesn't send response
  connectionRetryTimeout: 90000,
  //
  // Default request retries count
  connectionRetryCount: 3,

  services: ['chromedriver'],
  framework: 'mocha',

  mochaOpts: {
    ui: 'bdd',
    timeout: 0,
  },
};
