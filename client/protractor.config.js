var browsers = {
  chrome: {
    name: 'Chrome',
    browserName: 'chrome'
  }
}

exports.config = {
  specs: [
    './e2e/**/*.spec.js'
  ],

  baseUrl: 'http://localhost:4567'
};

if (process.argv[3] === '--chrome') {
  exports.config.capabilities = browsers.chrome;
} else {
  exports.config.multiCapabilities = [
    browsers.chrome
  ]
}
