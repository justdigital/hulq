var gutil   = require('gulp-util');
var map     = require('map-stream');
var replace = require('gulp-replace');
var path    = require('path');
var fs      = require("fs");
var extend  = require('util')._extend
var PluginError = gutil.PluginError;
var DEBUG = true;

var debugOutput = function(msg){
  if (DEBUG)
    console.log(msg);
};

var defaultOptions = {
  replaces: {},
};

var fileContentsToTemplateSync = function(templateContent, filename, templateVariable){
  var _content = fs.readFileSync(filename, "utf8");
  templateContent = templateContent.replace("{{" + templateVariable + "}}", _content.trim());
  return templateContent;
};
 
var xsltTemplatePlugin = function(options) {
  options = extend(defaultOptions, options);
  return map(function(file, cb) {
    if (!options.partialsPath) {
      throw new PluginError('gulp-xslttemplate', 'Missing partialsPath option for gulp-xslttempalte');
    }
    var error;
    var fileName;

    if (!file) {
      throw new PluginError('gulp-xslttemplate', 'Missing file option for gulp-xslttempalte');
    }

    var templateContent = fs.readFileSync(file.path, "utf8");

    /*
     * Template substitution from options.replaces
     */
    for (var name in options.replaces){
      var _partial = options.replaces[name];
      var _path = _partial.path || "";
      var _filename = _partial.filename || name + '.' + _partial.type;
      _path = path.resolve(_path + "/" + _filename);

      templateContent = fileContentsToTemplateSync(templateContent, _path, name);
    }

    /*
     * Template substitution from partials
     */
    fs.readdir(options.partialsPath,function(err,files){
      if(err) throw err;
      files.forEach(function(file){
        // do something with each file HERE!
        var _path = path.resolve(options.partialsPath + "/" + file);
        var name  = file.replace(".xslt", "");
        debugOutput("Injecting file " + _path + " into variable " + name);
        templateContent = fileContentsToTemplateSync(templateContent, _path, name);
      });
      file.contents = new Buffer(String(templateContent));
      return cb(null, file);
    });
  });
};
 
module.exports = xsltTemplatePlugin;
