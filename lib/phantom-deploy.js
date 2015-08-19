// Requirements
var fs     = require("fs");
var system = require('system');
var page   = require("webpage").create();


var waitFor = function(testFx, onReady, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 3000, //< Default Max Timout is 3s
    start = new Date().getTime(),
    condition = false,
    interval = setInterval(function() {
      if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
        // If not time-out yet and condition not yet fulfilled
        condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
      } else {
        if(!condition) {
            // If condition still not fulfilled (timeout but condition is 'false')
        } else {
            // Condition fulfilled (timeout and/or condition is 'true')
            typeof(onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
            clearInterval(interval); //< Stop this interval
        }
      }
    }, 250); //< repeat check every 250ms
};

// Common validations
var args = system.args.slice(1);
var stylesheet = args[0];
var cwd = args[1];
if (!stylesheet){
  console.log("Please input a filename");
  phantom.exit(1);
}

var cfg = require(cwd + '/hulqfile.js');
cfg.defaultFrontend = args[1] || cfg.defaultFrontend;
cfg.defaultLanguage = args[2] || cfg.defaultLanguage;

page.onConsoleMessage = function(msg) {
  console.log(msg);
};

function logTheUserIn(){
  // Logs the user in
  var loginUrl = cfg.gsaProtocol + '://' + cfg.gsaHost + ':' + cfg.gsaPanelPort + "/EnterpriseController";
  console.log("Using url " + loginUrl);
  page.open(loginUrl, function(status){
    if (status !== 'success') {
      console.log("Error opening the login page: " + status);
      phantom.exit(1);
    }

    // Fill in the login form
    var logged = page.evaluate(function(cfg){
      var loginForm = document.getElementById('login_frm');
      if (loginForm){
        console.log("Logging in");
        loginForm.elements["username"].value = cfg.gsaLogin;
        loginForm.elements["passwd"].value = cfg.gsaPass;
        loginForm.elements["login"].click();
      }else{
        console.log("Login form not found, going to the upload page");
        return true;
      }
    }, cfg);
    
    waitFor(function(){
      return page.evaluate(function(){
        return !!document.getElementById("action_home");
      });
    }, goToUploadPage, 10000);
  });
}

// Go to the upload page
function goToUploadPage(){
  console.log("Going to the upload page");
  var uploadUrl = cfg.gsaProtocol + '://' + cfg.gsaHost + ':' + cfg.gsaPanelPort + "/EnterpriseController#a=viewFrontends";
  page.evaluate(function(){
    document.querySelector("a[href='#a=viewFrontends']").click();
  });

  waitFor(function(){
    return page.evaluate(function(){
      return !!document.getElementById("action_viewFrontends");
    });
  }, setFrontend, 10000);
}

function setFrontend(){
  console.log("Setting frontend: " + cfg.defaultFrontendName);
  page.evaluate(function(cfg){
    document.querySelector("form[name=editFrontend_" + cfg.defaultFrontendName + "] a").click();
  }, cfg);

  waitFor(function(){
    return page.evaluate(function(){
      return !!document.getElementById("fileName");
    });
  }, setLanguage, 10000);
}

function setLanguage(){
  console.log("Setting language: " + cfg.defaultFrontendLanguage);
  page.evaluate(function(cfg){
    document.querySelectorAll("#frontendForm select[name=frontendlanguage]")[0].value = cfg.defaultFrontendLanguage;
  }, cfg);

  waitFor(function(){
    return page.evaluate(function(cfg){
      return document.querySelectorAll("form[name=navwidget] input[name=frontendlanguage]")[0].value === cfg.defaultFrontendLanguage;
    }, cfg);
  }, uploadXSLT, 10000);
}


function uploadXSLT(){
  console.log("Uploading XSLT");
  var frontendPath = cwd + "/" + cfg.xsltBuildPath + "/" + stylesheet + ".xslt";

  var templateContent = fs.read(frontendPath);

  page.evaluate(function(templateContent){
    document.querySelector("textarea[name='stylesheet']").value = templateContent;
    document.querySelector("input[type='submit'][name='saveStylesheet']").click();
  }, templateContent);

  waitFor(function(){
    return page.evaluate(function(){
      return document.querySelectorAll("button[name=cancel]").length > 0;
    });
  }, confirmUpload, 10000);
}

function confirmUpload(){
  console.log("Confirming XSLT upload");
  page.evaluate(function(){
    document.querySelector("button[name=ok]").click();
  });

  waitFor(function(){
    return page.evaluate(function(){
      return (
        (
          document.querySelector("#activity-msg-bar") && 
          document.querySelector("#activity-msg-bar").innerHTML.indexOf("...") === -1
        ) ||
        (
          document.body.innerHTML.match(/Line \d+:.*/)
        )
      )
    });
  }, areWeDone, 10000);
}

function areWeDone(){
  var errors = page.evaluate(function(){
    return document.body.innerHTML.match(/Line \d+:.*/);
  });
  if (errors && errors.length > 0){
    console.log("There were errors:");
    for (var e in errors){
      var error = errors[e];
      console.log(error);
    }
  } else {
    console.log("Done.");
  }
  phantom.exit(0);
}

logTheUserIn();
