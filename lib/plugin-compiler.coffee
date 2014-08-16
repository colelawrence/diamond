{ normalize } = require 'path'
fs = require 'fs'
jade = require 'jade'
coffee = require 'coffee-script'

# Concatenates the jade runtime, diamond templates and diamond-client files

getTemplates = (callback) ->
  try
    templatesScript = '\nvar template={}\n'

    startString = '\ntemplate' # namespace

    templates = ["files"]
    templatesFolder = normalize __dirname + "/../src/templates/"

    runtimeJs = fs.readFileSync (normalize __dirname + "/../src/vendors/jade-runtime.js"), "utf8"
    templatesScript += runtimeJs + "\n"

    for templateName in templates
      jadeString = fs.readFileSync templatesFolder + templateName + ".jade", 'utf8'
      script = jade.compileClient(jadeString)

      script = '["' + templateName + '"] = ' + script    
      templatesScript += startString + script
  catch error
    callback error

  callback null, templatesScript

getCoffeeScript = (restURL, callback) ->
  coffeeScript = '\nvar restURL="' + restURL + '"\n'

  scriptFile = normalize __dirname + "/../src/coffee/diamond-client.coffee"

  coffeeString = fs.readFileSync scriptFile, 'utf8'
  try
    compiledObj = coffee.compile(coffeeString, { bare: true })
    coffeeScript += compiledObj
    callback null, coffeeScript
  catch error
    callback error

module.exports = (restURL, callback) ->
  pluginScript = '\n(function () {\n'
  # 1. Templates
  getTemplates (error, script) ->
    if error
      callback error
    else
      pluginScript += script
      getCoffeeScript restURL, (error, script) ->
        if error
          callback error
        else
          pluginScript += script
          pluginScript += '\n})()\n'
          callback null, pluginScript