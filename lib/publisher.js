var path = require("path")
var fs = require("fs")
var jade = require("jade")

timeLog = function (message) {
  console.log((new Date).toLocaleTimeString() + " - " + message);
}

module.export = function (fn) {
  var jadeOptions = {
    pretty: true
  }
  console.log(fn, fn.slice(0, -5) + ".html")
  var html = jade.renderFile("jade/" + fn, jadeOptions);
  fs.writeFileSync(fn.slice(0, -5) + ".html", html, "utf8")
  
  timeLog("published files")
}

srcFW = fs.watch("./jade", {
  interval: 500
});
srcFW.on("change", function(event, filename) {
  if (event === "change" && /jade$/i.test(filename)) module.export(filename);
});
