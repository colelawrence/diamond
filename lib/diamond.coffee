fs = require('fs')
{ resolve, relative } = require('path')

class Diamond
  constructor: (options) ->
    {
      @directoryHandler
      @directory
    } = options
  handle: (req, res, directory) ->
    console.log req.url
    path = (req.query.path ? "/")
      .replace /\\+/g, "/"    # Be normal
      .replace /\.\.+/g, "."  # Be safe :-)
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
    handleDirectory = (error, directory) ->
      if error? then next error
      else self.handle req, res, directory 
    if self.directoryHandler
      self.directoryHandler req, handleDirectory
    else if self.directory
      handleDirectory null, self.directory
    else
      throw new Error("No directoryHandler function or directory option passed to Diamond")
module.exports = (options) ->
  diamond = (new Diamond(options))
  diamond.middleware.bind diamond
