'use strict';

// Dependencies
var gulp              = require('gulp');
var xslttemplate      = require('./tasks/gulp-xslttemplate.js');
var gcallback         = require('gulp-callback')
var sass              = require('gulp-sass');
var concat            = require('gulp-concat');
var jshint            = require('gulp-jshint');
var sourcemaps        = require('gulp-sourcemaps');
var watch             = require('gulp-watch');
var batch             = require('gulp-batch');
var cfg               = require('./config.js');


// CSS Tasks
gulp.task('css', function (cb) {
  gulp.src(cfg.cssPath + '/**/*.scss')
  .pipe(sourcemaps.init())
  .pipe(sass({
    outputStyle: 'compressed'
  }).on('error', sass.logError))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest(cfg.cssBuildPath))
  .pipe(gcallback(cb));
});

// JS Tasks
gulp.task('js', function(cb){
  gulp.src([
    //You can add important files first like libraries so they'll be on the beginning of the main file
    cfg.jsPath + "/header.js",  //(Unlimited) Important stuff first
    cfg.jsPath + '/**/*.js'     //All the other files
  ])

  //You can ignore js lint on library files using /*ignore jslint start */ and /*ignore jslint end */
  .pipe(jshint({
    browser: true,
  }))

  .pipe(concat('app.js'))
  .pipe(gulp.dest(cfg.jsBuildPath))
  .pipe(gcallback(cb));
});

// XSLT Building
gulp.task('xslt', ['js', 'css'], function() {
  gulp.src(cfg.xsltPath + '/template.xslt')
  .pipe(xslttemplate({
    partialsPath: cfg.xsltPartialsPath,
    replaces: {
      jsmin: {
        filename: "app.js",
        path: cfg.jsBuildPath,
      },
      cssmin: {
        filename: "app.css",
        path: cfg.cssBuildPath,
      },
    }
  }))
  .pipe(gulp.dest(cfg.xsltBuildPath));
});

gulp.task('default', ['xslt']); //Default runs only xslt because it already depends on CSS and JS tasks

// Watch
gulp.task('watch', function () {
  watch([cfg.xsltPath + "/*.xslt", cfg.xsltPartialsPath + "/**/*.xslt", cfg.jsPath + '/**/*.js', cfg.cssPath + '/**/*.scss'], batch(function (done) {
    gulp.start('xslt');
    done();
  }));
});
