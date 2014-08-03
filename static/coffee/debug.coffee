this.Log = ->
  args = Array::slice.call(arguments)
  console.log.bind(console).apply this, args