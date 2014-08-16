require('coffee-script/register') # Needed to require modules written in coffee-script

class Diamond
  fs = require('fs')
  { resolve, relative } = require('path')
  pluginCompiler = require './plugin-compiler'
  compiledScript = null
  constructor: (options) ->
    {
      @directoryHandler
      @directory
      @debug
    } = options
  handle: (req, res, directory) ->
    path = (req.query.path ? "/")
      .replace /\\+/g, "/"    # Be normal
      .replace /\.\.+/g, "."  # Be safe :-)
      .replace /^\//, ""      # Be relative
    if @debug
      console.log "REST GET", { path }
    path = resolve directory, path
    fs.stat path, (error, stats) ->
      try
        if stats.isFile()
          res.json { contents: fs.readFileSync path, "utf8" }
        else if stats.isDirectory()
          dir = fs.readdirSync path
          files = []
          for fileName in dir
            {mtime, ctime, mode, size} = fs.lstatSync path + '/' + fileName
            files.push {mtime, ctime, mode, size, name: fileName}
          res.json { files }
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
    debug = @debug
    if compiledScript
      send compiledScript
    else
      pluginCompiler restURL, (error, script) ->
        if error
          if debug
            console.error error
          res.status 501
          res.json JSON.stringify(error).replace(/\\n|\\r/g, "\n").replace(/\n\n+/g, "\n")
        else
          if not debug
            compiledScript = script
          send script
module.exports = (options) ->
  diamond = (new Diamond(options))
  diamond.middleware.bind diamond
