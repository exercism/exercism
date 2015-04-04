var gulp = require('gulp');
var requireDir = require('require-dir');

var dir = requireDir('./tasks');

/**
 * Default gulp task. Run 'gulp clean', 'gulp build', 'gulp copy'
 * and 'gulp watch'. You can find other gulp tasks in './tasks' folder
 */
gulp.task('default', ['clean', 'build', 'watch']);
