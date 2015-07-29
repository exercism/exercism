!function(){
  module.exports = function(ngModule) {
    ngModule.controller('CommentsCtrl', function($scope, $http) {
      $scope.commentThread = {};
      $scope.hideCommentForm = true;

      $scope.showCommentForm = function() {
        $scope.hideCommentForm = false;
      };

      $scope.hideCommentForm = function() {
        $scope.hideCommentForm = true;
      };

      $scope.addComment = function(commentId) {
        var commentThreadBody = $scope.commentThread.body;
        var url = '/comments/' + commentId + '/comment_threads';

        $http.post(url, $.param({
          'body': commentThreadBody
        }), {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        }).success(function(data, status, headers) {
          $scope.commentThreads.push(data);
          $scope.hideCommentForm = true;
          return $scope.commentThread.body = '';
        }).error(function(data, status, headers) {
          return alert(data.body);
        });
      };
    });
  };
}(this);
