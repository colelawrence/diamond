require('coffee-script/register') // Needed to require modules written in coffee-script
var express = require('express')
var path = require('path')
var cookieParser = require('cookie-parser')
var bodyParser = require('body-parser')
var session = require('express-session')

var app = express()

// view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

// Form data access
app.use(bodyParser.json())
app.use(bodyParser.urlencoded())

app.use(cookieParser())
app.use(session({
    secret: 'such secretz'
}))

app.use('/diamond', require('./lib/diamond')({
    directory: __dirname
}))

app.use(express.static(path.join(__dirname, 'static')))

/// Routes
app.use('/', require('./routes/'))

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found')
    err.status = 404
    next(err)
})

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500)
        res.render('error', {
            message: err.message,
            error: err
        })
    })
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500)
    res.render('error', {
        message: err.message,
        error: {}
    })
})


module.exports = app
