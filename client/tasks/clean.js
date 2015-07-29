var gulp = require('gulp');
var clean = require('gulp-clean');
var distFiles = [
  '../lib/app/public/js/bundle.js',
  '../lib/app/public/js/bundle.js.map'
]

 /**
 * Delete bundle.js from '../lib/app/public/js' directory. After getting rid
 * of old front end, this task should delete contents of whole directory.
 */
 gulp.task('clean', function() {
  return gulp.src(distFiles, {read: false})
    .pipe(clean({force: true}));
 });
