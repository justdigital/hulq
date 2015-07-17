'use strict';

// Dependencies
var gulp              = require('gulp');
var xslttemplate      = require('./tasks/gulp-xslttemplate.js');
var sass              = require('gulp-sass');
var concat            = require('gulp-concat');
var jslint            = require('gulp-jslint');
var sourcemaps        = require('gulp-sourcemaps');
var watch             = require('gulp-watch');
var batch             = require('gulp-batch');

/*
  Config
*/
//No trailing slash for paths!
var jsPath            = "./assets/js";
var jsBuildPath       = "./assets/build/js";
var cssPath           = "./assets/css";
var cssBuildPath      = "./assets/build/css";
var xsltPath          = "./xslt";
var xsltPartialsPath  = "./xslt/partials";
var xsltBuildPath     = "./xslt/build";
/*
  Config End
*/


// CSS Tasks
gulp.task('css', function () {
  gulp.src(cssPath + '/**/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass({
      outputStyle: 'compressed'
    }).on('error', sass.logError))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./assets/build/css'));
});

// JS Tasks
gulp.task('js', function(){
  gulp.src([
    //You can add important files first like libraries so they'll be on the beginning of the main file
    jsPath + "/header.js",  //(Unlimited) Important stuff first
    jsPath + '/**/*.js'     //All the other files
  ])
  .pipe(concat('app.js'))
  .pipe(jslint({
    browser: true,
  }))
  .pipe(gulp.dest(jsBuildPath));
});

// XSLT Building
gulp.task('xslt', function() {
  gulp.src('xslt/template.xslt')
    .pipe(xslttemplate({
      destPath: xsltBuildPath,
      partialsPath: xsltPartialsPath,
      replaces: {
        jsmin: {
          filename: "app.js",
          path: jsBuildPath,
        },
        cssmin: {
          filename: "app.css",
          path: cssBuildPath,
        },
        advanced_search: {
          type: "xslt",
          path: xsltPartialsPath
        },
      }
    }))
    .pipe(gulp.dest(xsltBuildPath));
});

gulp.task('default', ['js', 'css', 'xslt']);

// Watch
gulp.task('watch', function () {
  watch(cssPath + '/**/*.scss', batch(function (done) {
    gulp.start(['css']);
    done();
  }));

  watch(jsPath + '/**/*.js', batch(function (done) {
    gulp.start(['js']);
    done();
  }));

  watch([xsltPartialsPath, jsBuildPath, cssBuildPath], batch(function (done) {
    gulp.start('xslt');
    done();
  }));
});
