var gulp         = require('gulp');
var xslttemplate = require('./tasks/gulp-xslttemplate.js');

gulp.task('default', function() {
  gulp.src('xslt/template.xslt')
    .pipe(xslttemplate({
      partials: {
        header: {
          //TODO: css: 'css1.css'
        }
      }
    }))
});
