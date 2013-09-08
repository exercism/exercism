# Exports an object that defines
 #  all of the paths & globs that the project
 #  is concerned with.
 #
 # The "configure" task will require this file and
 #  then re-initialize the grunt config such that
 #  directives like <config:files.js.app> will work
 #  regardless of the point you're at in the build
 #  lifecycle.
 #
 # To see the default definitions for all of Lineman's file paths and globs, look at:
 # https://github.com/testdouble/lineman/blob/master/config/files.coffee
 #
 
module.exports = require(process.env['LINEMAN_MAIN']).config.extend('files', {
  js:
    vendor: [
      "vendor/js/**/*jquery*",
      "vendor/js/**/underscore.js",
      "vendor/js/**/angular.js",
      "vendor/js/**/*.js",
    ]
    app: [
      "app/js/namespace.js",
      "app/js/**/*.js"
    ]

  coffee:
    app: [
      "app/js/**/namespace.coffee",
      "app/js/**/*.coffee"
    ]

  css:
    vendor: [
      "vendor/css/bootstrap.css",
      "vendor/css/bootstrap-responsive.css",
      "vendor/css/**/*.css",
    ]
})
