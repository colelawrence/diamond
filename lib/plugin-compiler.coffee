{ normalize } = require 'path'
fs = require 'fs'
jade = require 'jade'
async = require 'async'
coffee = require 'coffee-script'

# Concatenates the jade runtime, diamond templates and diamond-client files

getTemplates = (callback) ->
  templatesScript = '\nvar template={}\n'
  
  startString = '\ntemplate' # namespace
  
  templates = ["files"]
  templatesFolder = normalize __dirname + "/../src/templates/"
  
  fs.readFile (normalize __dirname + "/../src/vendors/jade-runtime.js"), "utf8", (readError, runtimeJs) ->
    if readError
      callback readError
    else
      templatesScript += runtimeJs + "\n"

      async.each templates, (templateName, nextTemplate) ->

        fs.readFile templatesFolder + templateName + ".jade", 'utf8', (readError, jadeString) ->
          if (readError)
            nextTemplate(readError)
          else
            script = jade.compileClient(jadeString)
            
            script = '["' + templateName + '"] = ' + script
            
            templatesScript += startString + script
            nextTemplate()
      , (error) ->
        if error?
          callback error
        else
          callback null, templatesScript

getCoffeeScript = (restURL, callback) ->
  coffeeScript = '\nvar restURL="' + restURL + '"\n'

  scriptFile = normalize __dirname + "/../src/coffee/diamond-client.coffee"

  fs.readFile scriptFile, 'utf8', (readError, coffeeString) ->
    if readError
      callback readError
    else
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