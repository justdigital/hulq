var exec = require('child_process').exec;
var spawn = require('child_process').spawn;
var cwd  = process.env.PWD || process.cwd();

module.exports.start = function(){
  var gulpProc = spawn('gulp', ['watch'], {
    stdio: 'inherit',
      cwd: cwd
  });

  gulpProc.on('close', function (code) {
    process.exit(code);
  });
};
