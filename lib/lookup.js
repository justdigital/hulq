// Requirements
var wrench   = require("wrench");
var path     = require('path');
var lazy     = require("lazy");
var fs       = require("fs");
var chalk    = require("chalk");

var cfg = global.CONFIG;

// Command colors:
var fileColor = chalk.bold.blue;
var numColor  = chalk.blue;
var lineColor = chalk.green;
var highlightedColor = chalk.red.bgYellow;



module.exports.start = function(term){
  // Common validations
  if (!term){
    console.log("Please enter a search term");
    return;
  }

  function addMatch(file, line, lineNum){
    var highlightedLine = line.toString().trim().replace(new RegExp(term, "g"), highlightedColor(term));
    console.log(fileColor(file + ":") + numColor(lineNum) + " " + lineColor(highlightedLine));
  }

  wrench.readdirRecursive(cfg.xsltPath, function(error, curFiles) {
    for (var f in curFiles){
      var file = curFiles[f];
      if (file.match(".xslt")){
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
        })(1, file);
      }
    }
  });
};
