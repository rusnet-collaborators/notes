marked = require 'marked'
marked.setOptions
  renderer    : new marked.Renderer()
  gfm         : true
  tables      : true
  breaks      : true
  pedantic    : false
  sanitize    : false
  smartLists  : true
  smartypants : true

module.exports = marked
