var cfg      = require('./config.js');
var wrench   = require("wrench");
var path     = require('path');
var lazy     = require("lazy");
var fs       = require("fs");
var chalk    = require("chalk");

// Command colors:
var fileColor = chalk.bold.blue;
var numColor  = chalk.blue;
var lineColor = chalk.green;
var highlightedColor = chalk.red.bgYellow;

// Common validations
var args = process.argv.slice(2);
if (!args[0]){
  console.log("Please enter a search term");
  return;
}

var term = args[0];

function addMatch(file, line, lineNum){
  var highlightedLine = line.toString().trim().replace(new RegExp(term, "g"), highlightedColor(term));
  console.log(fileColor(file + ":") + numColor(lineNum) + " " + lineColor(highlightedLine));
}

wrench.readdirRecursive(cfg.xsltPath, function(error, curFiles) {
  for (var f in curFiles){
    var file = curFiles[f];
    if (file.match(".xslt") && !file.match("build")){
      (function(lineNum, file){
        new lazy(fs.createReadStream(cfg.xsltPath + "/" + file))
          .lines
          .forEach(function(line){
            if (line.toString().match(term)){
              addMatch(file, line, lineNum);
            }
            lineNum ++;
          }
        );
      })(0, file);
    }
  }
});
