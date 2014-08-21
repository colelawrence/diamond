
# globals: template, restURL

class Diamond
  openPath = (diamond, path) ->
  # from node
  `// private
  // resolves . and .. elements in a path array with directory names there
  // must be no slashes, empty elements, or device names (c:\) in the array
  // (so also no leading and trailing slashes - it does not distinguish
  // relative and absolute paths)
  function normalizeArray(parts, allowAboveRoot) {
    // if the path tries to go above the root, \`up\` ends up > 0
    var up = 0;
    for (var i = parts.length - 1; i >= 0; i--) {
      var last = parts[i];
      if (last === '.') {
        parts.splice(i, 1);
      } else if (last === '..') {
        parts.splice(i, 1);
        up++;
      } else if (up) {
        parts.splice(i, 1);
        up--;
      }
    }

    // if the path is allowed to go above the root, restore leading ..s
    if (allowAboveRoot) {
      for (; up--; up) {
        parts.unshift('..');
      }
    }

    return parts;
  }
  `
  sortByFolderAndName = (a, b) ->
    if a.mode is b.mode
      if a.name < b.name
        return -1
      else if a.name > b.name
        return 1
      else
        return 0
    else
      if a.mode < b.mode
        return -1
      else if a.mode > b.mode
        return 1
      else
        return 0

  # private
  fixPath = (path) ->
    f = "/"
    (path + f)
    .replace /\/\/+/g, f
    .replace /^\.\//g, ""
    .slice(0, -1)

  # private
  # Use fix path and normalizeArray to resolve .. and .
  normalize = (path) ->
    normalizeArray(fixPath(path).split("/"), false).join("/")

  constructor: (selector, options = {}) ->
    # restURL equals the path variable of app.use(path, diamond)
    # when we were required in our connect app.
    # For example: restURL = "/droppy" if app.use("/droppy", diamond)
    @restURL = restURL
    @currentPath = options.currentPath ? "."
    @debug = !!options.debug

    # Use @display or self.display to refer to the Element we are bound to.
    @display = $ selector

    self = @

    @display.on "click", ".entry", ->
      self.setPath this.dataset.path

    # initiallize
    @setPath @currentPath

  # overwritable
  onOpenDirectory: (path, files) ->
    files = files.sort sortByFolderAndName
    @display.html template["files"]({ currentPath: path, files})

  # public
  # Set the current path no higher than the original
  setPath: (path) ->
    self = @
    newPath = normalize(path)
    $.getJSON @restURL, { path: newPath }
    .done (data) ->
      methods = self
      self.currentPath = newPath
      if self.debug
        console.log data
      handler = "onOpen" + data.type[0].toUpperCase() + data.type.slice(1)
      if self.debug
        console.log "<diamond>", handler, newPath, data[data.type]
      self[handler]?(newPath, data[data.type])

this.Diamond = Diamond
