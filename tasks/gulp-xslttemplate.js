var gutil   = require('gulp-util');
var map     = require('map-stream');
var replace = require('gulp-replace');
var path    = require('path');
var fs      = require("fs");
var extend  = require('util')._extend
var PluginError = gutil.PluginError;

var defaultOptions = {
  destPath: './xslt/build/',
  replaces: {},
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

    /*
     * Template generating
     */
    for (var name in options.replaces){
      var _partial = options.replaces[name];
      var _path = _partial.path || "";
      var _filename = _partial.filename || name + '.' + _partial.type;

      _path = path.resolve(_path + "/" + _filename);
      var _content = fs.readFileSync(_path, "utf8");
      templateContent = templateContent.replace("{{" + name + "}}", _content.trim());
    }

    file.contents = new Buffer(String(templateContent));
    return cb(null, file);
  });
};
 
module.exports = xsltTemplatePlugin;
