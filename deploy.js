/* Allow unsigned https requests */
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

/* Requirements */
var fs          = require("fs");
var cfg         = require('./config.js');
var request     = require("request");

// Common validations
var args = process.argv.slice(2);
if (!args[0]){
  console.log("Please input a filename");
  return;
}

var frontend, filename, language;


// The authorization function
var authorize = function(cb){
  cb = cb || function(){};
  
  request.post(
    cfg.gsaProtocol + '://' + cfg.gsaHost + ':' + cfg.gsaPanelPort + "/accounts/ClientLogin",
    { 
      form: {
        Email:  cfg.gsaLogin,
        Passwd: cfg.gsaPass
      } 
    },
    function (error, response, body) {
      if (!error && response.statusCode == 200) {
        if (body.toLowerCase().indexOf("success") > -1){
          var authCode = body.replace(/[\s\S]*Auth=(.*)[\s\S]*/, "$1");
          cb(null, authCode);
        }
      }else if (error){
        cb(error, null);
      }else{
        cb("Status code error: " + response.statusCode, null);
        console.log(response);
      }
    }
  );
}

var getCurrent = function(authToken, frontend, stylesheet, language, cb){
  language = language || "en";
  var frontendHost = cfg.gsaProtocol + '://' + cfg.gsaHost + ':' + cfg.gsaPanelPort + "/feeds/outputFormat/" + frontend;
  var frontendContent = fs.readFileSync(cfg.xsltBuildPath + "/" + stylesheet  + ".xslt", "utf-8");

  request.get(
    frontendHost,
    {
      headers: {
        'Content-type':  'application/atom+xml',
        'Authorization': 'GoogleLogin auth=' + authToken,
      }
    },
    function (error, response, body) {
      if (!error && response.statusCode == 200) {
        cb(null, body);
      }else if (error){
        cb(error, null);
      }else{
        cb("Status code error: " + response.statusCode, null);
        console.log(response.body);
      }
    }
  );
};

var upload = function(authToken, frontend, stylesheet, language, cb){
  language = language || "en";
  var frontendHost = cfg.gsaProtocol + '://' + cfg.gsaHost + ':' + cfg.gsaPanelPort + "/feeds/outputFormat/" + frontend;
  var frontendContent = fs.readFileSync(cfg.xsltBuildPath + "/" + stylesheet  + ".xslt", "utf-8");
  frontendContent = frontendContent
  /*
    // Transforms current entities in hulq format so they get parsed later
    .replace(/&apos;/g, "((HLQapos))")
    .replace(/&quot;/g, '((HLQquot))')
    .replace(/&gt;/g,   '((HLQgt))')
    .replace(/&lt;/g,   '((HLQlt))')
    .replace(/&amp;/g,  '((HLQamp))')

    // Converts XML special chars in entities
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');

  /*
    // Converts hulq format entities to CDATA encapsulated entities
    .replace(/\(\(HLQamp\)\)/g,     '<![CDATA[&]]>')
    .replace(/\(\(HLQlt\)\)/g,      '<![CDATA[<]]>')
    .replace(/\(\(HLQgt\)\)/g,      '<![CDATA[>]]>')
    .replace(/\(\(HLQquot\)\)/g,    '<![CDATA["]]>')
    .replace(/\(\(HLQapos\)\)/g,    "<![CDATA[']]>");

  */
  var requestData = 
    "<?xml version='1.0' encoding='UTF-8'?>" +
      "<entry xmlns='http://www.w3.org/2005/Atom' " +
      "xmlns:gsa='http://schemas.google.com/gsa/2007'>" +
        "<id>" + frontendHost + "</id>" +
        "<gsa:content name='entryID'>" + frontend + "</gsa:content>" +
        "<gsa:content name='styleSheetContent'>" +
          frontendContent + 
        "</gsa:content>" +
        "<gsa:content name='isDefaultLanguage'>1</gsa:content>" +
      "</entry>";

  request.put(
    frontendHost,
    {
      body: requestData,
      headers: {
        'Content-type':  'application/atom+xml',
        'Authorization': 'GoogleLogin auth=' + authToken,
      }
    },
    function (error, response, body) {
      if (!error && response.statusCode == 200) {
        cb(null, body);
      }else if (error){
        cb(error, null);
      }else{
        cb("Status code error: " + response.statusCode, null);
        console.log(response.body);
      }
    }
  );
}

// Start it!
authorize(function(err, authToken){
  if (err) {
    console.log(err);
  }
  upload(authToken, "default_frontend", "template", "lang_en", function(err, body){
    if (err){
      console.log(err);
      return;
    }else{
      console.log(body);
      console.log("Done.");
    }
  });
});

