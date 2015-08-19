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
        prepare(true);
        console.log(completeColor("Installing gulp locally..."));
        npm.load({
          loaded: false
        }, function (err) {
          if (err){
            console.log(errorColor("Error installing gulp locally, try it manually (npm install gulp)"));
            return;
          }
          npm.commands.install(["gulp@3.9.0"], function (er, data) {
            // log the error or data
            console.log(completeColor("Complete!"));
          });
          npm.on("log", function (message) {
            // log the progress of the installation
            console.log(message);
          });
        });
      });
    });
  }else{
    cb();
  }
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
        console.log(completeColor("HulQ project '" + project + "' has been created"));
      });
    });
  });
};
