// Requirements
var fs       = require("fs");
var request  = require("request");
var chalk    = require("chalk");
var wrench   = require("wrench");
var readline = require('readline');
var path     = require('path');

var cfg = global.CONFIG;

// Colors
var errorColor    = chalk.bold.red;
var completeColor = chalk.bold.green;
var fileColor     = chalk.yellow;

var confirmation = function(force, cb){
  if (force) cb();
  else{
    var rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });
    rl.question(fileColor("Previous files on the workspace will be deleted automatically. Are you sure? (y/n)"), function(answer){
      rl.close();
      if (answer.toLowerCase() === "y"){
        cb();
      }else{
        console.log(fileColor("No changes have been made"));
      }
    });
  }
};

module.exports.start = function(force, cb){
  cb = cb || function(){};
  console.log(fileColor("Preparing the workspace..."));
  confirmation(force, function(){
    wrench.copyDirRecursive(cfg.generatedPath, cfg.xsltPath, {
        forceDelete: true,
        excludeHiddenUnix: true,
        preserveFiles: true,
        filter: /.*\.xslt/g,
      }, function(err){
      if (!err){
        console.log(completeColor("Moved generated files from " + cfg.generatedPath + " to " + cfg.xsltPath));
        cb()
      }
      else
        console.log(errorColor(err));
    });
  });
};
