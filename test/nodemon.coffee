# This is for development purposes
devreload = require 'devreload'
ndm = require 'nodemon'
p = require 'path'

if devreload
  # Use devreload for reloading the browser
  try
    devreload.listen {watch:[__dirname+'/views', __dirname+'/static', p.normalize(__dirname+'/../src')], port:9999}
  catch e
    devreload = null
start = ->
  ext = 'js coffee'
  watch = ['routes/','lib/','app.js', p.normalize(__dirname+'/../lib')]
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
