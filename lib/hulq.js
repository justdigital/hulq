var args = process.argv.slice(2);
var command = args[0];

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
  default:
    require('./help.js').start();
}
