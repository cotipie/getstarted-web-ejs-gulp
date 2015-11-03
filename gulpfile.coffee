gulp = require 'gulp'
bower = require 'gulp-bower-files'
flatten = require 'gulp-flatten'
uglify = require 'gulp-uglify'
autoprefixer = require 'gulp-autoprefixer'
sass = require 'gulp-sass'
del = require 'del'
runSequence = require 'run-sequence'
ejs = require 'gulp-ejs'
browserSync = require 'browser-sync'
imagemin = require 'gulp-imagemin'
plumber = require 'gulp-plumber'
filter = require 'gulp-filter'
notify = require 'gulp-notify'

gulp.task 'bower', ->
  bower()
    .pipe flatten()
    .pipe (gulp.dest 'lib')

gulp.task 'fonts', ->
  gulp.src 'lib/fontawesome-webfont.*'
    .pipe (gulp.dest 'dist/fonts')

gulp.task 'csslib', ->
  gulp.src 'lib/*.css'
    .pipe (gulp.dest 'dist/css')

gulp.task 'jslib', ->
  gulp.src 'lib/*.js'
    .pipe uglify({preserveComments:'some'})
    .pipe (gulp.dest 'dist/js')

gulp.task 'libClean', (cb)->
  del ['lib'], cb

gulp.task 'releaseClean', (cb)->
  del ['dist'], cb

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
    .pipe ejs()
    .pipe (gulp.dest 'dist')

gulp.task 'imagemin', ->
  gulp.src 'images/{,**/}*.{png,jpg,gif}'
    .pipe imagemin()
    .pipe (gulp.dest 'dist/images')

gulp.task 'server', ->
  browserSync({
    notify: false,
    server: {
      baseDir: "dist"
  	}
  })

gulp.task 'getstart', (cb)->
  runSequence 'bower',['fonts','csslib','jslib'],'default',cb

gulp.task 'default', ->
	gulp.start 'build:sass','build:ejs','build:js','imagemin'

gulp.task 'release', (cb)->
  runSequence 'releaseClean','bower',['fonts','csslib','jslib'],'libClean','default',cb

gulp.task 'watch',->
	gulp.start 'server'
	gulp.watch 'sass/**/*.scss',['build:sass',browserSync.reload]
	gulp.watch 'ejs/*.ejs',['build:ejs',browserSync.reload]
	gulp.watch 'js/*.js',['build:js',browserSync.reload]
	gulp.watch 'images/{,**/}*.{png,jpg,gif}',['imagemin',browserSync.reload]
