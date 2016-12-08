# Exports an object that defines
#  all of the configuration needed by the projects'
#  depended-on grunt tasks.
#
# You can familiarize yourself with all of Lineman's defaults by checking out the parent file:
# https://github.com/testdouble/lineman/blob/master/config/application.coffee
#

module.exports = require(process.env['LINEMAN_MAIN']).config.extend('application', {
  removeTasks:
    common: ['copy:dev', 'webfonts:dev', 'images:dev', 'concat_sourcemap', 'pages:dev']
    dist: ['images:dist', 'webfonts:dist', 'pages:dist', 'cssmin']

  server:
    apiProxy:
      enabled: true
      host: 'localhost'
      port: 4567

  # enableSass: true

  # configure lineman to load additional angular related npm tasks
  loadNpmTasks: ['grunt-ngmin']

  # task override configuration
  prependTasks:
    dev: ['copy:dev']
    dist: ['ngmin']         # ngmin should run in dist only

  appendTasks:
    common: ['concat_sourcemap:js', 'concat_sourcemap:spec'],

  watch:
    scripts:
      files: ['generated/**']
      tasks: ['copy:dev']

  copy:
    dev:
      files: [
        expand: true
        cwd: 'generated'
        src: ['js/**', '!**/spec.js', '!**/*.coffee*', '!**/spec.js.map']
        dest: '../public'
      ]
    dist:
      files: [
        expand: true
        cwd: 'dist'
        src: ['js/**']
        dest: '../public'
      ]

  # configuration for grunt-ngmin, this happens _after_ concat once, which is the ngmin ideal :)
  ngmin:
    js:
      src: '<%= files.js.concatenated %>'
      dest: '<%= files.js.concatenated %>'

  uglify:
    options:
      banner: "<%= meta.banner %>"
      sourceMap: "<%= files.js.minified %>.map"
      sourceMapIn: "<%= files.js.concatenated %>.map"
      sourceMappingURL: "<%= files.js.sourceMapUrl %>"

})
