angular.module('exercism').controller("MarkdownCtrl", function($scope, $http) {
  $scope.data = {};
  $scope.preview = function(){
    $http.post(
        "/preview",
        $.param( { "comment": $scope.data.comment }),
        { headers: { "Content-Type": 'application/x-www-form-urlencoded' } })
    .success(function(data, status, headers) {
      $scope.data.preview = data;
    });
  };
});
