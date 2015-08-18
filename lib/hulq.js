// Requirements
var chalk = require("chalk");
var args = process.argv.slice(2);
var fs       = require("fs");


// Colors
var errColor = chalk.bold.red;
var cmdColor = chalk.bold.green;

var command = args[0];

var isValidDirectory = function(){
  return fs.existsSync("hulqfile.js");
};

var noCommand = function(){
  var message = "";
  console.log(errColor("No command specified. Use ") + cmdColor("hulq begin project_name") + errColor(" to start a new project"));
};

if (!isValidDirectory() && command !== "begin"){
  console.log(errColor("You must run a hulq command inside a hulq project directory (no hulqfile.js found). If you just created your project, enter its directory using ") + cmdColor("cd project_name") + errColor("."));
  return 1;
}

switch(command){
  case 'smash':
    require("./smash.js").start(args[1]);
    break;
  case 'begin':
    require("./begin.js").start(args[1]);
    break;
  case 'prepare':
    require("./prepare.js").start();
    break;
  case 'destroy':
    require("./destroy.js").start();
    break;
  case 'lookup':
    require("./lookup.js").start(args[1]);
    break;
  case 'recover':
    require("./recover.js").start();
    break;
  case 'watch':
    require("./watch.js").start();
    break;
  case 'deploy':
    require("./deploy.js").start(args[1]);
    break;
  case 'help':
    require('./help.js').start();
    break;
  default:
    noCommand();
}
