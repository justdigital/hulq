var chalk = require("chalk");
var S = require('string');

// Help colors
var title   = chalk.bold.blue;

var helpTable = {
  _lines: [],
  title: title("Welcome to HulQ help. These are the available commands:\n"),
  verticalSpacing: 1,
  columns: [
    {
      size:30,                   // Col size
      colorFunc: chalk.bold.red, // Col color
      paddingRight: 3,           // Amount of spaces to the next table
    },
    {
      size:70,
      colorFunc: chalk.green
    }
  ],

  // Add table line function
  addLine: function(arr){
    var sequel = [];
    var curLine = [];

    // Loop to get all columns information
    for (var i = 0; i < this.columns.length; i++){
      if (arr[i]){
        var colLength = this.columns[i].size;
        curLine[i] = arr[i].substr(0, colLength);

        var _sequel = arr[i].slice(colLength);
        if (_sequel){
          sequel[i] = _sequel;
        }
      }
    }

    // Add the line to the line list
    this._lines.push(curLine);

    // If there are column leftovers, call recursively addLine on the sequels
    if (sequel.length > 0){
      this.addLine(sequel);
    }else{
      for(var i = 0; i < this.verticalSpacing; i++){
        this._lines.push([]);
      }
    }
  },

  // Render the table
  render: function(){
    console.log(this.title);
    for (var l in this._lines){
      var line = this._lines[l];
      var lineStr = "";
      if (line.length > 0){
        for (var i = 0;i < this.columns.length;i++){
          var colStr = line[i] || "";
          var _col = S(colStr.trim()).padRight(this.columns[i].size);
          var pr = this.columns[i].paddingRight || 0;
          lineStr += this.columns[i].colorFunc(_col) + S("").padRight(pr);
        }
        console.log(lineStr);
      }else{
        // Spacing empty line
        console.log();
      }
    }
  }
};

module.exports.start = function(){
  helpTable.addLine(["begin project_name", "Starts a new hulq project. If the file project_name.xslt exists in the current working directory, the smash and prepare commands will be automatically executed."]);
  helpTable.addLine(["smash file_to_smash", "Smashes the specified xslt on the resources folder (configurable) into many pieces"]);
  helpTable.addLine(["prepare", "Moves the generated files into the workspace directory"]);
  helpTable.addLine(["destroy", "Removes the generated files"]);
  helpTable.addLine(["lookup search_term", "Finds a term inside any xslt file on the workspace"]);
  helpTable.addLine(["recover", "Generates the XSLT output that can be uploaded"]);
  helpTable.addLine(["watch", "Starts watching project files and automatically runs recover on file changes"]);
  helpTable.addLine(["deploy", "Sends the generated file to the server"]);
  helpTable.addLine(["help", "Shows this help"]);
  helpTable.render();
};
