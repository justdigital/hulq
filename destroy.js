// Requirements
var fs      = require("fs");
var cfg     = require('./config.js');
var request = require("request");
var chalk   = require("chalk");
var wrench   = require("wrench");

// Colors
var errorColor = chalk.bold.red;
var completeColor = chalk.bold.green;
var fileColor = chalk.yellow;

wrench.readdirRecursive(cfg.generatedPath, function(error, curFiles){
  for (var f in curFiles){
    var file = cfg.generatedPath + "/" + curFiles[f];
    (function(file){
      if (file.match(".xslt")){
        fs.unlink(file, function(err){
          if (err) {
            console.log(errorColor(err));
          } else {
            console.log(fileColor("Deleting " + file));
          }
        });
      }
    })(file);
  }
});
