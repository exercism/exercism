var gulp = require('gulp');
var webpack = require('gulp-webpack-build');
var livereload = require('gulp-livereload');

var webpackConfigPath = './webpack.config.js';


/*
 * Run webpack. Webpack's configuration is in './webpack.config.js' file.
 * Task outputs 'bundle.js' file into './dist' folder containing all
 * application's modules bundled together.
 */
 gulp.task('build', function() {
  gulp.src(webpackConfigPath)
    .pipe(webpack.compile())
    .pipe(webpack.failAfter({
        errors: true,
        warnings: true
    }));
 });
