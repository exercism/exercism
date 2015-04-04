var gulp = require('gulp');
var karma = require('gulp-karma');

/*
 * Run unit tests
 */
gulp.task('test', function() {
  return gulp.src('./app/main.js')
    .pipe(karma({
      configFile: './karma.conf.js',
      action: 'run'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});
