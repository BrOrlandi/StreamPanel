gulp = require 'gulp'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
sass = require 'gulp-sass'
del = require 'del'
gulpif = require 'gulp-if'
plumber = require 'gulp-plumber'

env = process.env.ENV or 'dev'
isDev = env is 'dev'
isProd = env is 'prod'

outputDir = 'public'

paths = 
    scripts: 'coffee_client/**/*.coffee'
    styles: 'sass/**/*.scss'
    server: ['*.coffee', '!gulpfile.coffee']

gulp.task 'clean_styles', (cb)->
    del outputDir + '/css' , cb

gulp.task 'clean_scripts', (cb)->
    del outputDir + '/js' , cb

gulp.task 'scripts', ['clean_scripts'], ->
    gulp.src paths.scripts
        .pipe plumber()
        .pipe gulpif isDev, sourcemaps.init()
        .pipe coffee()
        .pipe gulpif isProd, uglify()
        .pipe concat 'main.js'
        .pipe gulpif isDev, sourcemaps.write()
        .pipe gulp.dest outputDir + '/js'

gulp.task 'styles', ['clean_styles'], ->
    config = {}
    config.sourceComments = 'map' if isDev
    config.outputStyle = 'compressed' if isProd

    gulp.src paths.styles
        .pipe plumber (error)->
            console.error error.message
            this.emit 'end'
        .pipe sass config
        .pipe gulp.dest outputDir + '/css'

gulp.task 'server', ->
    gulp.src paths.server
        .pipe plumber()
        .pipe gulpif isDev, sourcemaps.init()
        .pipe coffee()
        .pipe gulpif isDev, sourcemaps.write()
        .pipe gulp.dest '.'

gulp.task 'watch', ->
    gulp.watch paths.scripts, ['scripts']
    gulp.watch paths.styles, ['styles']
    gulp.watch paths.server, ['server']

gulp.task 'default', ['scripts','styles','server','watch']