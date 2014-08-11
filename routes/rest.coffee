express = require('express')
router = express.Router()
fs = require('fs')
{ resolve, relative } = require('path')

{ filesDirectory } = require '../config.js'

router.get '/', (req, res) ->
  path = (req.query.path ? "./")
    .replace /\\+/g, "/"
  console.log "REST GET", { path }
  path = resolve path
  safetyCheck = relative filesDirectory, path
  console.log safetyCheck
  if safetyCheck.indexOf("..\\") isnt -1
    res.status 501
    res.end "Invalid path format."
  else
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

module.exports = router
