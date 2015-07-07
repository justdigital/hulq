var gutil   = require('gulp-util');
var map     = require('map-stream');
var replace = require('gulp-replace');
var path    = require('path');
var fs      = require("fs");
var extend  = require('util')._extend
var PluginError = gutil.PluginError;

var defaultOptions = {
  destFolder: "build",
  destFilename: "template.xslt",
  xsltFolder: "xslt",
  partials: {},
  partialsFolder: "partials",
  partialsExtension: "xslt"
};
 
var xsltTemplatePlugin = function(options) {
  options = extend(defaultOptions, options);

  return map(function(file, cb) {
    var error;
    var fileName;

    if (!file) {
      throw new PluginError('gulp-xslttemplate', 'Missing file option for gulp-xslttempalte');
    }

    var templateContent = fs.readFileSync(file.path, "utf8");

    for (var name in options.partials){
      var _partial = options.partials[name];
      var _path = path.resolve(options.xsltFolder + "/" + options.partialsFolder + "/" + name + "." + options.partialsExtension);
      var _partialContent = fs.readFileSync(_path, "utf8");
      templateContent = templateContent.replace("{{" + name + "}}", _partialContent);
    }

    var _destPath = path.resolve(options.xsltFolder + "/" + options.destFolder + "/" + options.destFilename);
    fs.writeFile(_destPath, templateContent, function(err) {
      cb(err, file);
    });

  });
};
 
module.exports = xsltTemplatePlugin;
