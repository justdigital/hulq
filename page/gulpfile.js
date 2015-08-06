var gulp = require('gulp');
var postcss = require('gulp-watch');
var cssnext = require('cssnext');
var cssnano = require('cssnano');

gulp.task('css', function () {
  var postcss = require('gulp-postcss');
  return gulp.src([
      'css/bootstrap.min.css',
      'css/hulq.min.css',
      'css/*.css'
    ])
    .pipe( postcss([ cssnext(), cssnano() ]) )
    .pipe( gulp.dest('css/build/') );
});
