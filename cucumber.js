var path = require('path');
global.__base = path.resolve(__dirname) + '/';

module.exports = {
  default: `--format-options '{"snippetInterface": "synchronous"}'`
}