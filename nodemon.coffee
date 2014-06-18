# This is for development purposes
devreload = require 'devreload'
ndm = require 'nodemon'
p = require 'path'

if devreload
  # Use devreload for reloading the browser
  try
    devreload.listen {watch:[__dirname+'/static/coffee', __dirname+'/static/templates', __dirname+'/views'], port:9999}
  catch e
    devreload = null

willWatchStatic = '--static' in process.argv or '--all' in process.argv
willWatchVend = '--vendors' in process.argv or '--all' in process.argv
willWatchGraphics = '--graphics' in process.argv or '--all' in process.argv
start = ->
  ext = 'coffee js'
  watch = ['routes/','lib/','app.js']
  if willWatchVend
    watch.push 'static/vendors/'
    ext += ' css'
  if willWatchStatic
    watch.push 'static/js'
    watch.push 'static/styl'
    ext += ' styl'
  if willWatchGraphics
    watch.push 'static/graphics'
    ext += ' jpg png svg gif'
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