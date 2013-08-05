angular.module('exercism').controller "MarkdownCtrl", ($scope, $http) ->
  $scope.data = {}
  $scope.preview = ->
    $http.post "/preview",
        $.param({ "comment": $scope.data.comment }),
        headers:
          "Content-Type": 'application/x-www-form-urlencoded'
    .success (data, status, headers) ->
      $scope.data.preview = data
