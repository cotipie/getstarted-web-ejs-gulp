gulp = require 'gulp'
bower = require 'gulp-bower-files'
flatten = require 'gulp-flatten'
uglify = require 'gulp-uglify'
autoprefixer = require 'gulp-autoprefixer'
sass = require 'gulp-sass'
del = require 'del'
runSequence = require 'run-sequence'
ejs = require 'gulp-ejs'
webserver = require 'gulp-webserver'
plumber = require 'gulp-plumber'
filter = require 'gulp-filter'
notify = require 'gulp-notify'

gulp.task 'bower', ->
  bower()
    .pipe flatten()
    .pipe (gulp.dest 'lib')

gulp.task 'csslib', ->
  gulp.src 'lib/*.css'
    .pipe (gulp.dest 'dist/css')

gulp.task 'jslib', ->
  gulp.src 'lib/*.js'
    .pipe uglify({preserveComments:'some'})
    .pipe (gulp.dest 'dist/js')

gulp.task 'libClean', (cb)->
  del ['lib'], cb

gulp.task 'build:js',->
  gulp.src 'js/*.js'
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe uglify({preserveComments:'some'})
    .pipe (gulp.dest 'dist/js')

gulp.task 'build:sass',->
  gulp.src 'sass/**/*.scss'
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe sass({
      outputStyle: 'compressed'
      })
    .pipe filter('**/*.css')
    .pipe autoprefixer('last 2 version')
    .pipe (gulp.dest 'dist/css')

gulp.task 'build:ejs', ->
  gulp.src ['ejs/*.ejs','!ejs/_*.ejs']
    .pipe plumber({errorHandler: notify.onError('<%= error.message %>')})
    .pipe ejs({},{ext: '.html'})
    .pipe (gulp.dest 'dist')

gulp.task 'webserver', ->
  gulp.src './dist'
    .pipe webserver({
      host: '127.0.0.1',
      livereload: true
    })

gulp.task 'getstart', (cb)->
  runSequence 'bower',['csslib','jslib'],'default',cb

gulp.task 'default', ->
	gulp.start 'build:sass','build:ejs','build:js'

gulp.task 'release', (cb)->
  runSequence 'bower',['csslib','jslib'],'libClean','default',cb

gulp.task 'watch',->
	gulp.start 'webserver'
	gulp.watch 'sass/**/*.scss',['build:sass']
	gulp.watch 'ejs/*.ejs',['build:ejs']
	gulp.watch 'js/*.js',['build:js']
