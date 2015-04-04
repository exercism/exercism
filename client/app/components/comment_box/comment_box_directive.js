/*
 * Usage: <comment-box></comment-box>
 */

!(function() {
  'use strict';

  module.exports = function(ngModule) {

    if(getEnv() === 'test') {
      require('./comment_box_directive.spec')(ngModule);
    }

    ngModule.directive('commentBox', CommentBox);

    function CommentBox() {
      require('./comment_box.sass');

      return {
        restrict: 'E',
        template: require('./comment_box.html'),
        controllerAs: 'vm',
        controller: function() {
          var vm = this;

          vm.greeting = 'Hello';
        }
      };
    };
  };
})();
