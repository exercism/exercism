/*
 * Main application file. This is the place to require modules and plugins
 * for angular app.
 */
!(function() {
  'use strict';

  window._ = require('underscore');
  window.jQuery = window.$ = require('jquery/dist/jquery');
  window.Chart = require('Chart.js/Chart.js');
  require('jquery.cookie/jquery.cookie');
  require('jquery.atwho/dist/js/jquery.atwho');
  require('angular');
  require('angular-bootstrap/dist/ui-bootstrap-tpls');
  require('bootstrap/dist/js/npm');
  require('jquery-caret/jquery.caret');
  require('./vendor/jquery.zclip');
  require('theia-sticky-sidebar/js/theia-sticky-sidebar');
  require('./old');

  if(getEnv() === 'test') {
    require('angular-mocks/angular-mocks');
  }

  var ngModule = angular.module('exercism', [
    'ui.bootstrap'
  ]);

  require('./old/controllers')(ngModule);
  require('./components/comment_box')(ngModule);
})(this);
