var gulp = require('gulp');
var cssnext = require('cssnext');
var cssnano = require('cssnano');
var postcss = require('gulp-postcss');

gulp.task('css', function () {
  return gulp.src([
      'css/bootstrap.min.css',
      'css/hulq.min.css',
      'css/*.css'
    ])
    .pipe( postcss([ cssnext(), cssnano() ]) )
    .pipe( gulp.dest('css/build/') );
});
