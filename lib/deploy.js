var spawn = require('child_process').spawn;
var cwd  = process.env.PWD || process.cwd();

module.exports.start = function(file){
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
