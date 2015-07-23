var fs      = require("fs");
var args = process.argv.slice(2);
if (!args[0]){
  console.log("Please input a filename");
  return;
}

var createFile = function(name, content){
  fs.writeFile("./generated/" + name + ".xslt", content, function(err) {
    if (err) {console.log(err); return;}
  });
}

var resourceFilePath = "./resources/" + args[0] + ".xslt";

fs.readFile(resourceFilePath, {encoding: "utf8"}, function(err, templateContent){
  if (err){
    console.log("The XSLT file was not available: (" + resourceFilePath + ")");
    return;
  }
  templateContent = templateContent.replace(/<xsl:template\s+name="(.*)">((?:[\s\S])*?)<\/xsl:template>/g, function(match, p1, p2, offset, string){
    createFile("partials/" + p1.toLowerCase(), p2.trim());
    return match.replace(p2, "{{" + p1.toLowerCase() + "}}");
  });

  createFile("template", templateContent);
  console.log("Done.");
});
