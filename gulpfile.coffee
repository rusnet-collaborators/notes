$            = (require 'gulp-load-plugins')()
config       = require './config.coffee'
del          = require 'del'
gulp         = require 'gulp'
gulpsync     = $.sync gulp
path         = require 'path'
htmlincluder = require 'gulp-htmlincluder'

gulp.task 'clean', ->
  del config.prod_path, force: true

gulp.task 'gen_js', ->
  gulp.src path.join config.dev_path_coffee, '*.coffee'
    .pipe $.coffee bare: true
    .pipe gulp.dest config.prod_path_js

gulp.task 'gen_js_live', ->
  gulp.src path.join config.dev_path_coffee, '*.coffee'
    .pipe $.coffee bare: true
    .pipe gulp.dest config.prod_path_js

gulp.task 'gen_css', ->
  gulp.src path.join config.dev_path_sass, '*.sass'
    .pipe $.sass indentedSyntax: true
    .pipe $.autoprefixer
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

gulp.task 'gen_css_live', ->
  gulp.src path.join config.dev_path_sass, '*.sass'
    .pipe $.sass indentedSyntax: true
    .pipe $.autoprefixer
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

gulp.task 'gen_markdown', ->
  gulp.src path.join config.database_path, '*.md'
    .pipe $.markdown()
    .pipe gulp.dest config.dev_path

gulp.task 'gen_html', ->
  gulp.src path.join config.dev_path, '*.html'
    .pipe htmlincluder()
    .pipe gulp.dest config.prod_path
  return

gulp.task 'gen_html_live', ->
  gulp.src path.join config.dev_path, '*.html'
    .pipe htmlincluder()
    .pipe gulp.dest config.prod_path
  return

gulp.task 'copy', ->
  gulp.src path.join(config.dev_path_css, '**/*'),   base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_img, '**/*'),   base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_favicon, '**/*'),   base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_js, '**/*'),    base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_json, '**/*'),  base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_fonts, '**/*'), base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join(config.dev_path_json, '**/*'),  base: config.dev_path
    .pipe gulp.dest config.prod_path
  gulp.src path.join config.dev_path, 'CNAME'
    .pipe gulp.dest config.prod_path
  return

gulp.task 'default', gulpsync.sync [
  'clean'
  'gen_js'
  'gen_css'
  'gen_markdown'
  'gen_html'
  'copy'
]

gulp.task 'html', gulpsync.sync [
  'gen_html'
]

gulp.task 'deploy', [], $.shell.task [ 'surge ' + config.prod_path ]

gulp.task 'watcher', ->
  gulp.watch path.join(config.dev_path_coffee, '*.coffee'), ['gen_js_live']
  gulp.watch path.join(config.dev_path_sass, '*.sass'), ['gen_css_live']
  gulp.watch path.join(config.dev_path, '*.html'), ['gen_html_live']
  return

