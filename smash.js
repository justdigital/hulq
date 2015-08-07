// Requirements
var fs    = require("fs");
var cfg   = require('./config.js');
var chalk = require("chalk");

// Colors
var errorColor = chalk.bold.red;
var noticeColor = chalk.blue;
var fileColor = chalk.yellow;
var completeColor = chalk.bold.green;

var args = process.argv.slice(2);
if (!args[0]){
  console.log(errorColor("Please input a filename"));
  return;
}

var createFile = function(name, content){
  var fName = "./generated/" + name + ".xslt";
  console.log(noticeColor("Creating file: ") + fileColor(fName));
  fs.writeFile(fName, content, function(err) {
    if (err) {console.log(errorColor(err)); return;}
  });
}

var resourceFilePath = "./resources/" + args[0] + ".xslt";

fs.readFile(resourceFilePath, {encoding: "utf8"}, function(err, templateContent){
  if (err){
    console.error(errorColor("The XSLT file was not available: (" + resourceFilePath + ")"));
    return;
  }
  templateContent = templateContent.replace(/<xsl:template\s+name="([a-zA-Z0-9_]*?)">((?:[\s\S])*?)<\/xsl:template>/g, function(match, p1, p2, offset, string){
    createFile("partials/" + p1.toLowerCase(), p2.trim());
    return match.replace(p2, "{{" + p1.toLowerCase() + "}}");
  });

  createFile("template", templateContent);
  console.log(completeColor("Done creating files."));
});
