// Requirements
var chalk = require("chalk");
var fs    = require("fs");
var path  = require('path');

// Colors
var errColor = chalk.bold.red;
var cmdColor = chalk.bold.green;

var args  = process.argv.slice(2);
var command = args[0];


var newProject = true;
if (fs.existsSync("hulqfile.js")){
  var cwd = process.env.PWD || process.cwd();
  global.CONFIG = require(path.resolve(cwd, 'hulqfile.js'));
  newProject = false;
}else{
  global.CONFIG = require(path.resolve(__dirname, "scaffolding", 'hulqfile.js'));
}


var noCommand = function(){
  var message = "";
  console.log(errColor("No command specified. Use ") + cmdColor("hulq begin project_name") + errColor(" to start a new project"));
};

if (newProject && command !== "begin"){
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
