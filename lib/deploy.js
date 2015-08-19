// Requirements
var spawn = require('child_process').spawn;
var chalk = require("chalk");
var fs    = require("fs");
var path  = require('path');

var errorColor = chalk.bold.red;

var cwd   = process.env.PWD || process.cwd();
var cfg = global.CONFIG;

module.exports.start = function(file){
  file = file || cfg.outputFileName;
  if (!fs.existsSync(path.resolve(cwd, cfg.xsltBuildPath, file + ".xslt"))){
    console.log(errorColor("Deploy file not found, make sure you have used 'hulq recover' already"));
    return;
  }
  var gulpProc = spawn('phantomjs',
    [
      '--web-security=false',
      '--ignore-ssl-errors=true',
      '--cookies-file=cookies',
      'phantom-deploy.js',
      file,
      cwd
    ],
    {
      stdio: 'inherit',
      cwd: __dirname
    }
  );

  gulpProc.on('close', function (code) {
    process.exit(code);
  });
};
