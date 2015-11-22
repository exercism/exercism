var gulp = require('gulp');
var clean = require('gulp-clean');

 /**
 * Delete bundle.js from '../public/js' directory. After getting rid
 * of old front end, this task should delete contents of whole directory.
 */
 gulp.task('clean', function() {
  return gulp.src('../public/js/bundle.js', {read: false})
    .pipe(clean({force: true}));
 });
