var express = require('express')
var router = express.Router()
var fs = require('fs')

router.get('/', function (req, res) {
  res.render("index", { view: "index" })
})

router.get('/:view', function(req, res) {
  var view = req.params.view

  fs.exists('./views/' + view + '.jade', function (viewExists) {
    if (viewExists && view !== "index")
      res.render(view, { view: view })
    else
      res.redirect('/')
  })
})

module.exports = router
