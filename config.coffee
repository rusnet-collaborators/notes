path = require 'path'

root = __dirname

database_path    = path.join root, 'database'

dev_path         = path.join root, 'dev'
dev_path_js      = path.join dev_path, 'js'
dev_path_coffee  = path.join dev_path, 'coffee'
dev_path_css     = path.join dev_path, 'css'
dev_path_sass    = path.join dev_path, 'sass'
dev_path_img     = path.join dev_path, 'img'
dev_path_fonts   = path.join dev_path, 'fonts'

prod_path        = path.join root, 'prod'
prod_path_js     = path.join prod_path, 'js'
prod_path_coffee = path.join prod_path, 'coffee'
prod_path_css    = path.join prod_path, 'css'
prod_path_sass   = path.join prod_path, 'sass'
prod_path_img    = path.join prod_path, 'img'
prod_path_fonts  = path.join prod_path, 'fonts'

module.exports =
  root:             root

  database_path:    database_path

  dev_path:         dev_path
  dev_path_js:      dev_path_js
  dev_path_coffee:  dev_path_coffee
  dev_path_css:     dev_path_css
  dev_path_sass:    dev_path_sass
  dev_path_img:     dev_path_img
  dev_path_fonts:   dev_path_fonts

  prod_path:        prod_path
  prod_path_js:     prod_path_js
  prod_path_coffee: prod_path_coffee
  prod_path_css:    prod_path_css
  prod_path_sass:   prod_path_sass
  prod_path_img:    prod_path_img
  prod_path_fonts:  prod_path_fonts
