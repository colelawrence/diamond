require('coffee-script/register') # Needed to require modules written in coffee-script
fs = require('fs')
{ resolve, relative } = require('path')
pluginCompiler = require './plugin-compiler'

class Diamond
  constructor: (options) ->
    {
      @directoryHandler
      @directory
    } = options
  handle: (req, res, directory) ->
    path = (req.query.path ? "/")
      .replace /\\+/g, "/"    # Be normal
      .replace /\.\.+/g, "."  # Be safe :-)
      .replace /^\//, ""      # Be relative
    console.log "REST GET", { path }
    path = resolve directory, path
    fs.stat path, (error, stats) ->
      try
        if stats.isFile()
          res.json { contents: fs.readFileSync path, "utf8" }
        else if stats.isDirectory()
          res.json { files: fs.readdirSync path }
        else
          res.json { contents: "" }
      catch error
        res.status 501
        res.end error.message
  middleware: (req, res, next) ->
    self = @
    restURL = req.baseUrl
    if req.url is "/diamond.js"
      return @servePlugin(res, restURL)
    handleDirectory = (error, directory) ->
      if error? then next error
      else self.handle req, res, directory 
    if self.directoryHandler
      self.directoryHandler req, handleDirectory
    else if self.directory
      handleDirectory null, self.directory
    else
      throw new Error("No directoryHandler function or directory option passed to Diamond")
  servePlugin: (res, restURL) ->
    send = (script) ->
      res.setHeader 'Content-Type', 'text/javascript'
      res.end script
    pluginCompiler restURL, (error, script) ->
      if error
        console.error error
        res.status 501
        res.json JSON.stringify(error).replace(/\\n|\\r/g, "\n").replace(/\n\n+/g, "\n")
      else
        send script
module.exports = (options) ->
  diamond = (new Diamond(options))
  diamond.middleware.bind diamond
