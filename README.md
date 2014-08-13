Diamond
======

Diamond is a very easy to use middleware & browser plugin combination for file system exploration.


### 1. Use middleware <sup><sub>app.js</sub></sup>

```javascript
app.use('/diamond', require('./lib/diamond')({
  directory: __dirname
}))
```

### 2. Include plugin <sup><sub>layout.jade</sub></sup>

```jade
  script(src="/vendors/jquery-2.1.1/jquery-2.1.1.min.js")
  script(src="/diamond/diamond.js")
```

### 3. Initialize <sup><sub>client-script.js</sub></sup>

```javascript
  demo = new Diamond("#demo")
  demo.onOpenFile = function (path, data) {
    console.log("opened file: ", path)
    console.log("file contents: ", data)
  }
```
