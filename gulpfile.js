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
var cfg               = require('./config.js');


// CSS Tasks
gulp.task('css', function () {
  gulp.src(cfg.cssPath + '/**/*.scss')
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
    cfg.jsPath + "/header.js",  //(Unlimited) Important stuff first
    cfg.jsPath + '/**/*.js'     //All the other files
  ])
  .pipe(concat('app.js'))
  .pipe(jslint({
    browser: true,
  }))
  .pipe(gulp.dest(cfg.jsBuildPath));
});

// XSLT Building
gulp.task('xslt', function() {
  gulp.src('xslt/template.xslt')
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
        advanced_search: {
          type: "xslt",
          path: cfg.xsltPartialsPath
        },
      }
    }))
    .pipe(gulp.dest(cfg.xsltBuildPath));
});

gulp.task('default', ['js', 'css', 'xslt']);

// Watch
gulp.task('watch', function () {
  watch(cfg.cssPath + '/**/*.scss', batch(function (done) {
    gulp.start(['css']);
    done();
  }));

  watch(cfg.jsPath + '/**/*.js', batch(function (done) {
    gulp.start(['js']);
    done();
  }));

  watch([cfg.xsltPartialsPath, cfg.jsBuildPath, cfg.cssBuildPath], batch(function (done) {
    gulp.start('xslt');
    done();
  }));
});
