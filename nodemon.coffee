# This is for development purposes
devreload = require 'devreload'
ndm = require 'nodemon'
p = require 'path'

if devreload
  # Use devreload for reloading the browser
  try
    devreload.listen {watch:[__dirname+'/views', __dirname+'/static'], port:9999}
  catch e
    devreload = null
start = ->
  ext = 'js'
  watch = ['routes/','lib/','app.js']
  ndm {
    script: 'bin/www'
    watch
    ext
  }
  .on 'restart', ->
    devreload.reload() if devreload
  .on 'log', (log) ->
    console.log log.colour
start()