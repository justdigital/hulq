// Requirements
var fs       = require("fs");
var request  = require("request");
var chalk    = require("chalk");
var wrench   = require("wrench");
var readline = require('readline');
var path     = require('path');

// Colors
var errorColor    = chalk.bold.red;
var completeColor = chalk.bold.green;
var fileColor     = chalk.yellow;

var cwd  = process.env.PWD || process.cwd();

module.exports.start = function(project){

  var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  console.log(fileColor("Initializing HulQ..."));
  rl.question(fileColor("A new folder will be created, existing content will be overwritten. Are you sure? (y/n)"), function(answer){
    rl.close();
    if (answer.toLowerCase() === "y"){
      wrench.copyDirRecursive(__dirname + "/scaffolding", cwd + "/" + project, {
          forceDelete: true,
          excludeHiddenUnix: true,
          preserveFiles: false,
        }, function(err){
        if (!err)
          console.log(completeColor("HulQ project '" + project + "' has been created"));
        else
          console.log(errorColor(err));
      });
    }else{
      console.log(fileColor("No changes have been made"));
    }
  });

};
