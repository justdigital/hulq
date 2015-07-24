# README #

Gulp XSLTTemplate

## Documentation ##

If you want to inject partials to a template just call the xslttemplate() function.

### Available options ###
- replaces: Besides the files loaded in the partials folder, you can add more replace rules in the options like this:

- partialsPath (required): The path to the partials folder. gulp-xslttemplate will automatically inject the partial files on the template where their variable is. The partial variable on the template is the file name by default. Example: The './partials/advanced_search.xslt' will be represented by the {{advanced_search}} variable.

```
var options = {
  partialsPath: './partials' //No trailing slash
  replaces: {
    
    jsmin: {
      // The name of the file to replace
      filename: 'app.js'

      // The file path with no trailing slash
      path: './assets/js'
    },

    external_template: {
      // If the filename is the same as the partial name, you can
      // omit the 'filename' option and specify a type
      // In this example our file would be: './external/external_template.xslt'
      type: 'xslt'
       
      // The file path with no trailing slash
      path: './external'
    }

  }
};
xssttemplate(options);
```

### Example implementation ###
_gulpfile.js_
```
var xslttemplate = require('./tasks/gulp-xslttemplate.js');

gulp.task('xslt', function() {
  gulp.src('xslt/template.xslt')
    .pipe(xslttemplate({
      partialsPath: './xslt/partials',
      replaces: {
        jsmin: {
          filename: "app.js",
          path: './assets/js',
        },
        cssmin: {
          filename: "app.css",
          path: './assets/css',
        },
      }
    }))
    .pipe(gulp.dest('./xslt/build/template.xslt'));
});
```
