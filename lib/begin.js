// Requirements
var fs       = require("fs");
var request  = require("request");
var chalk    = require("chalk");
var wrench   = require("wrench");
var readline = require('readline');
var path     = require('path');
var smash    = require("./smash.js").start;
var prepare  = require("./prepare.js").start;
var npm      = require("npm");

// Colors
var errorColor    = chalk.bold.red;
var completeColor = chalk.bold.green;
var fileColor     = chalk.yellow;

var cwd  = process.env.PWD || process.cwd();

var confirmation = function(cb){
  var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  console.log(fileColor("Initializing HulQ..."));
  rl.question(fileColor("A new folder will be created, existing content will be overwritten. Are you sure? (y/n)"), function(answer){
    rl.close();
    if (answer.toLowerCase() === "y"){
      cb();
    }else{
      console.log(fileColor("No changes have been made"));
    }
  });

};

var scaffold = function(project, cb){
  wrench.copyDirRecursive(__dirname + "/scaffolding", cwd + "/" + project, {
    forceDelete: true,
    excludeHiddenUnix: true,
    preserveFiles: false,
  }, cb);
};

var prepareResources = function(template, cb){
  var initialTemplate = template + ".xslt";
  var projectFolder = "./" + template;
  if (fs.existsSync(initialTemplate)){
    fs.rename(initialTemplate, path.resolve(projectFolder, "resources", initialTemplate) ,function(err){
      if (err){
        console.log(errorColor("Could not move " + initialTemplate + " to the resources folder:"));
        console.log(errorColor(err));
        return;
      }
      console.log(completeColor("Entering project directory..."));
      process.chdir(projectFolder);
      smash(template, function(){
        prepare(true, function(){
          cb();
        });
      });
    });
  }else{
    cb();
  }
};

var installDeps = function(cb){
  cb = cb || function(){};
  console.log(completeColor("Installing npm dependencies locally..."));
  npm.load({
    loaded: false
  }, function (err) {
    if (err){
      console.log(errorColor("Error installing npm dependencies locally"));
      return;
    }
    npm.commands.install([
      "hulq",
      "gulp@3.9.0",
      "chalk@1.1.0",
      "gulp-batch@1.0.5",
      "gulp-callback@0.0.3",
      "gulp-concat@2.6.0",
      "gulp-jshint@1.11.2",
      "gulp-replace@0.5.3",
      "gulp-sass@2.0.3",
      "gulp-sourcemaps@1.5.2",
      "gulp-util@3.0.6",
      "gulp-watch@4.3.1",
      "lazy@1.0.11",
      "lazy-cache@0.2.3",
      "map-stream@0.0.6",
      "request@2.60.0",
      "string@3.3.0",
      "wrench@1.5.8"
      ], function (er, data) {
      // log the error or data
      cb();
    });
    npm.on("log", function (message) {
      // log the progress of the installation
      console.log(message);
    });
  });
};

module.exports.start = function(project){
  if (project.match(".xslt")){
    project = project.replace(".xslt", "");
  }
  confirmation(function(){
    scaffold(project, function(err){
      if (err){
        console.log(errorColor(err));
        return;
      }
      prepareResources(project, function(err){
        installDeps(function(){
          console.log(completeColor("HulQ project '" + project + "' has been created"));
        });
      });
    });
  });
};
