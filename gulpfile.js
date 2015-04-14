var gulp = require('gulp'),
    watch = require('gulp-watch'),
    del = require('del'),
    plumber = require('gulp-plumber'),
    concat = require('gulp-concat'),
    runSequence = require('run-sequence'),
    livescript = require('gulp-livescript'),
    livereload = require('gulp-livereload');

gulp.task("clean", function (cb) {
  return del(['test'],cb);
});

gulp.task("watch", function () {
   livereload.listen();
   watch('lib/html/**/*.html', function (files, cb) {
     gulp.start("build-html",cb);
   });
   watch('lib/ls/**/*.ls', function (files, cb) {
     gulp.start("build-js");
   });
});

gulp.task("build-html", function () {
  return gulp.src('lib/html/*.html').
    pipe(plumber()).
    pipe(gulp.dest("test/")).
    pipe(livereload());
});

gulp.task("build-js", function () {
  return gulp.src([
      'lib/ls/test.ls',
      'lib/ls/polymorph.ls',
      'lib/ls/logic.ls'
    ]).
    pipe(plumber()).
    pipe(livescript({bare: true})).
    pipe(gulp.dest("test/")).
    pipe(livereload());
});

gulp.task("build-data", function () {
  return gulp.src('lib/data/*').
    pipe(gulp.dest("test/"));
});

gulp.task("build-js-components", function () {
  return gulp.src([
    'node_modules/async/lib/async.js',
    'node_modules/d3/d3.min.js',
    'node_modules/topojson/topojson.min.js'
    ]).
    pipe(concat('components.js')).
    pipe(gulp.dest('test/'));
});

// Run all the listeners and such for development
gulp.task("default", function (cb) {
  runSequence('clean', // Clean first
     ['build-html', // These in parallel
     'build-js',
     'build-js-components',
     'build-data',
     'watch'],cb);
});
