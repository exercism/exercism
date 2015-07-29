var gulp = require('gulp');
var webpack = require('gulp-webpack-build');
var livereload = require('gulp-livereload');

var webpackDevelopmentConfigPath = './webpack.config.js';
var webpackProductionConfigPath = './webpack.config.production.js';


/*
 * Run webpack. Webpack's configuration is in './webpack.config.js' file.
 * Task outputs 'bundle.js' file into './dist' folder containing all
 * application's modules bundled together.
 */
 gulp.task('build', function() {
  gulp.src(webpackDevelopmentConfigPath)
    .pipe(webpack.compile())
    .pipe(webpack.failAfter({
        errors: true,
        warnings: true
    }));
 });

/*
 * Run webpack. Webpack's configuration is in './webpack.config.production.js'
 * file. Task outputs 'bundle.js' file into './dist' folder containing all
 * application's modules bundled together.
 */
 gulp.task('build:production', function() {
  gulp.src(webpackProductionConfigPath)
    .pipe(webpack.compile())
    .pipe(webpack.failAfter({
        errors: true,
        warnings: true
    }));
 });
