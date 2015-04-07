!function(){
  module.exports = function(ngModule) {
    ngModule.controller('MarkdownCtrl', function($scope, $http, $sce) {
      var PATTERN;

      PATTERN = /\B@[a-z0-9_-]+/gi;

      $scope.data || ($scope.data = {});

      $scope.$watch('data.body', function(body) {
        var query, submission_key;

        if (body && PATTERN.test(body)) {
          query = body.match(PATTERN)[0].replace('@', '');
          submission_key = $('.md-markdown-preview textarea').attr('data-submission-key');

          $http.get("/api/v1/user/find", {
            params: {
              query: query,
              submission_key: submission_key
            }
          }).success(function(data, status, headers) {
            $('.comment').atwho({
              at: '@',
              data: data
            });
          });
        }
      });

      $scope.preview = function() {
        $http.post("/comments/preview", $.param({
          "body": $scope.data.body
        }), {
          headers: {
            "Content-Type": 'application/x-www-form-urlencoded'
          }
        }).success(function(data, status, headers) {
          $scope.data.preview = $sce.trustAsHtml(data);
        });
      };
    });
  };
}(this);
