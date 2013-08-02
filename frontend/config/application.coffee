# Exports an object that defines
#  all of the configuration needed by the projects'
#  depended-on grunt tasks.
#
# You can familiarize yourself with all of Lineman's defaults by checking out the parent file:
# https://github.com/testdouble/lineman/blob/master/config/application.coffee
#

module.exports = require(process.env['LINEMAN_MAIN']).config.extend('application', {
  removeTasks:
    common: [ "webfonts:dev", "images:dev"]
    dist: ["images:dist", "webfonts:dist", "pages:dist"]

  server:
    apiProxy:
      enabled: true
      host: 'localhost'
      port: 4567

  # enableSass: true

  # task override configuration
  prependTasks:
    common: ["ngtemplates"]  # ngtemplates runs in dist and dev

  
  # configuration for grunt-angular-templates
  ngtemplates:
    exorcism: # "exorcism" matches the name of the angular module defined in app.js
      options:
        base: "app/templates"
      src: "app/templates/**/*.html",
      # puts angular templates in a different spot than lineman looks for other templates in order not to conflict with the watch process
      dest: "generated/angular/template-cache.js"
  
  # configures grunt-watch-nospawn to listen for changes to
  # and recompile angular templates
  watch:
    ngtemplates:
      files: "app/templates/**/*.html",
      tasks: ["ngtemplates"]
    jsSpecs:
      files: ["<%= files.js.specHelpers %>", "<%= files.js.spec %>"],
    coffeeSpecs:
      files: ["<%= files.coffee.specHelpers %>", "<%= files.coffee.spec %>"],
      tasks: ["coffee"]
})
