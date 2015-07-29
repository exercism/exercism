var gulp = require('gulp');
var protractor = require('gulp-protractor').protractor;

/*
 * Download and update the selenium driver
 */
var webdriverUpdate = require('gulp-protractor').webdriver_update;

/*
 * Download the selenium webdriver
 */
gulp.task('webdriver-update', webdriverUpdate);

/*
 * Run protractor e2e tests
 */
gulp.task('e2e', function() {
  gulp.src(['./e2e/**/*.spec.js'])
    .pipe(protractor({
        configFile: 'protractor.config.js',
        args: ['--baseUrl', 'http://127.0.0.1:4567']
    }))
    .on('error', function(e) { throw e })
});
