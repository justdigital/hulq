// Requirements
var fs       = require("fs");
var cfg      = require('./config.js');
var request  = require("request");
var chalk    = require("chalk");
var wrench   = require("wrench");
var readline = require('readline');

// Colors
var errorColor    = chalk.bold.red;
var completeColor = chalk.bold.green;
var fileColor     = chalk.yellow;

var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

console.log(fileColor("Preparing the workspace..."));
rl.question(fileColor("Previous files on the workspace will be deleted automatically. Are you sure? (y/n)"), function(answer){
  rl.close();
  if (answer.toLowerCase() === "y"){
    wrench.copyDirRecursive(cfg.generatedPath, cfg.xsltPath, {
        forceDelete: true,
        excludeHiddenUnix: true,
        preserveFiles: true,
        filter: /.*\.xslt/g,
      }, function(err){
      if (!err)
        console.log(completeColor("Moved from " + cfg.generatedPath + " to " + cfg.xsltPath));
      else
        console.log(errorColor(err));
    });
  }else{
    console.log(fileColor("No changes have been made"));
  }
});
