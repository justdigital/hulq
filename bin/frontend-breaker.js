var fs      = require("fs");
var templateContent = fs.readFileSync("./res/default_frontend_stylesheet.en.xslt", "utf8");

var createFile = function(name, content){
  fs.writeFile("./generated/" + name + ".xslt", content, function(err) {
    if (err) {console.log(err); return;}
  });
}

//templateContent.replace("/<xsl:template>([\s\S]*)<\/xsl:template>/m", function(match, p1, offset, string){
templateContent = templateContent.replace(/<xsl:template\s+name="(.*)">((?:[\s\S])*?)<\/xsl:template>/g, function(match, p1, p2, offset, string){
  createFile("partials/" + p1.toLowerCase(), p2.trim());
  return match.replace(p2, "{{" + p1 + "}}");
});

createFile("template", templateContent);
console.log("Done.");
