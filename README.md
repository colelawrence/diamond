Diamond
======

Diamond is a very easy to use middleware & browser plugin combination for file system exploration.


### 1. Use middleware <super><sub>app.js</super></sub>

```javascript
app.use('/diamond', require('./lib/diamond')({
  directory: __dirname
}))
```

### 2. Include plugin <super><sub>layout.jade</super></sub>

```jade
  script(src="/vendors/jquery-2.1.1/jquery-2.1.1.min.js")
  script(src="/diamond/diamond.js")
```

### 3. Initialize <super><sub>client-script.js</super></sub>

```javascript
  demo = new Diamond("#demo")
  demo.onOpenFile = function (path, data) {
    console.log("opened file: ", path)
    console.log("file contents: ", data)
  }
```