/*
 * Main application file. This is the place to require modules and plugins
 * for angular app.
 */
!(function() {
  'use strict';

  require('angular');

  if(getEnv() === 'test') {
    require('angular-mocks/angular-mocks')
  }

  var ngModule = angular.module('exercism', []);

  require('./components/comment_box')(ngModule);
})();
