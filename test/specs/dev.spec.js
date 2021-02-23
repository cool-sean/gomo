const { pauseIfP } = require('../helpers');

describe('Webdriver Debug', () => {
  before(() => {});

  it('Puts the app in dev mode', () => {
    // TODO: work out how to do an interval here, we can't use the mobile object
    // in an setInterval function, it either has no access or the mobile is being used
    // in the debug.
    mobile.launchApp();
    mobile.debug();
  });
});
