var gulp = require('gulp');
var watch = require('gulp-watch');
var livereload = require('gulp-livereload');
var webpack = require('gulp-webpack-build');

var toWatch = ['./app/**/*.js', './app/**/*.scss', './app/**/*.html'];
var webpackConfigPath = './webpack.config.js';

/*
 * Start livereload server and listen to changes in js/css/html files in
 * './app' directory. On change bundle the application into 'bundle.js' file,
 * move it into './lib/app/public/js' directory and reload server.
 */
gulp.task('watch', function() {
  livereload.listen();
  gulp.watch(toWatch).on('change', function(e) {
    if (e.type === 'changed') {
      gulp.src(webpackConfigPath)
        .pipe(webpack.compile())
        .pipe(webpack.failAfter({
            errors: true,
            warnings: true
        }))
        .pipe(livereload());
    }
  });
});
