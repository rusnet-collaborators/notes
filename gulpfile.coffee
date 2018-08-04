gulp              = require 'gulp'
gulp_autoprefixer = require 'gulp-autoprefixer'
gulp_coffee       = require 'gulp-coffee'
gulp_ejs          = require 'gulp-ejs'
gulp_sass         = require 'gulp-sass'
gulp_util         = require 'gulp-util'

path     = require 'path'
marked   = require './helpers/marked'
hash_gen = require './helpers/hash_gen'
config   = require './config.coffee'

gulp.task 'gen_js', ->
  gulp.src path.join config.dev_path_coffee, '*.coffee'
    .pipe gulp_coffee bare: true
    .pipe gulp.dest config.prod_path_js

gulp.task 'gen_css', ->
  gulp.src path.join config.dev_path_sass, '*.sass'
    .pipe gulp_sass indentedSyntax: true
    .pipe gulp_autoprefixer
      browsers: [
        'Firefox ESR'
        'Firefox 14'
        'Opera 10'
        'last 2 version'
        'safari 5'
        'ie 8'
        'ie 9'
        'opera 12.1'
        'ios 6'
        'android 4'
      ]
      cascade: true
    .pipe gulp.dest config.prod_path_css

gulp.task 'gen_html', ->
  gulp.src path.join config.dev_path, 'index.ejs'
    .pipe gulp_ejs {asset_version: new Date().getTime(), marked: marked, env: process.env.NODE_ENV, hash_gen: hash_gen}, {}, ext: '.html'
    .pipe gulp.dest config.prod_path
  return

gulp.task 'copy', ->
  gulp.src path.join(config.dev_path_css,     '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_img,     '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_favicon, '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_js,      '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_json,    '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_fonts,   '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_json,    '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join config.dev_path, 'CNAME'
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path, 'favicon.ico')
    .pipe gulp.dest config.prod_path
  return

gulp.task 'default', [
  'gen_js'
  'gen_css'
  'gen_html'
  'copy'
]

gulp.task 'html', [
  'gen_html'
]

gulp.task 'watcher', ->
  gulp.watch path.join(config.dev_path_coffee, '*.coffee'), ['gen_js']
  gulp.watch path.join(config.dev_path_sass,   '*.sass'),   ['gen_css']
  gulp.watch path.join(config.dev_path,        '*.html'),   ['gen_html']
  return
