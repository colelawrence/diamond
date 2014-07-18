var express = require('express')
var router = express.Router()
var fs = require('fs')
var path = require('path')

var views = fs.readdirSync(path.resolve(__dirname, '../views'))

router.get('/', function (req, res) {
  res.render("index", { view: "index", views: views  })
})

router.get('/:view', function(req, res) {
  var view = req.params.view

  fs.exists('./views/' + view + '.jade', function (viewExists) {
    if (viewExists && view !== "index")
      res.render(view, { view: view, views: views })
    else
      res.redirect('/')
  })
})

module.exports = router
