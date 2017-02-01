'use strict';

const gulp        = require('gulp');
const gmocha      = require('gulp-mocha');

gulp.task('test', function() {
  return gulp.src(['test/tests.js'])
    .pipe(gmocha({timeout: 10000}));
});
