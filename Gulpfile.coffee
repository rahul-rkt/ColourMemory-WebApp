gulp        = require "gulp"
gutil       = require "gulp-util"
jade        = require "gulp-jade"
minifyHTML  = require "gulp-html-minifier"
sass        = require "gulp-sass"
coffee      = require "gulp-coffee"
clean       = require "gulp-clean"
run         = require "gulp-run"


# purge -----------------------------------------------------------------------
gulp.task "purge", ->
    gulp.src "./index.html", {read: false}
        .pipe clean()

    gulp.src "./assets/css/*.css", {read: false}
        .pipe clean()

    gulp.src "./assets/js/*.js", {read: false}
        .pipe clean()


# html ------------------------------------------------------------------------
gulp.task "html", ->
    gulp.src "./jade/index.jade"
        .pipe jade()
        .pipe minifyHTML(collapseWhitespace: true)
        .pipe gulp.dest("./")
        .on "error", gutil.log


# css -------------------------------------------------------------------------
gulp.task "css", ->
    gulp.src "./sass/master.sass"
        .pipe sass()
        .pipe sass(outputStyle: "compressed")
        .pipe gulp.dest("./assets/css/")
        .on "error", gutil.log


# js --------------------------------------------------------------------------
gulp.task "js", ->
    gulp.src "./coffee/*.coffee"
        .pipe coffee(bare: true)
        .pipe gulp.dest("./assets/js/")
        .pipe run("cd ./assets/js/optimize; node r.js -o config.js")
        .on "error", gutil.log


# default ---------------------------------------------------------------------
gulp.task "default", ["purge", "html", "css", "js"], ->
    gulp.watch "./jade/**/*.jade", ["html"]
    gulp.watch "./sass/**/*.sass", ["css"]
    gulp.watch "./coffee/**/*.coffee", ["js"]
