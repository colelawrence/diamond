fs = require('fs')

filesDirectory = __dirname// + "/files"
try {
  fs.mkdirSync(filesDirectory)
} catch (error) {}

exports.filesDirectory = filesDirectory