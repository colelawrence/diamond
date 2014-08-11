(function () { 
template["files"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;

var currentFolder = locals.currentPath.split("/"), folderPath = ""
buf.push("<div>");
// iterate currentFolder
;(function(){
  var $$obj = currentFolder;
  if ('number' == typeof $$obj.length) {

    for (var i = 0, $$l = $$obj.length; i < $$l; i++) {
      var folder = $$obj[i];

folderPath += (i?"/":"") + folder
if ( i)
{
buf.push("&nbsp;/&nbsp;");
}
buf.push("<span" + (jade.attr("data-path", folderPath, true, false)) + " class=\"entry\">" + (jade.escape(null == (jade_interp = folder) ? "" : jade_interp)) + "</span>");
    }

  } else {
    var $$l = 0;
    for (var i in $$obj) {
      $$l++;      var folder = $$obj[i];

folderPath += (i?"/":"") + folder
if ( i)
{
buf.push("&nbsp;/&nbsp;");
}
buf.push("<span" + (jade.attr("data-path", folderPath, true, false)) + " class=\"entry\">" + (jade.escape(null == (jade_interp = folder) ? "" : jade_interp)) + "</span>");
    }

  }
}).call(this);

buf.push("</div><div" + (jade.attr("data-path", locals.currentPath + "/../", true, false)) + " class=\"entry\"><strong>Parent Directory</strong></div>");
// iterate locals.files
;(function(){
  var $$obj = locals.files;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var file = $$obj[$index];

buf.push("<div" + (jade.attr("data-path", locals.currentPath + "/" + file, true, false)) + " class=\"entry\">" + (jade.escape(null == (jade_interp = file) ? "" : jade_interp)) + "</div>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var file = $$obj[$index];

buf.push("<div" + (jade.attr("data-path", locals.currentPath + "/" + file, true, false)) + " class=\"entry\">" + (jade.escape(null == (jade_interp = file) ? "" : jade_interp)) + "</div>");
    }

  }
}).call(this);
;return buf.join("");
}}())