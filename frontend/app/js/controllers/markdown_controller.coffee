angular.module('exercism').controller "MarkdownCtrl", ($scope, $http) ->
  $scope.data ||= {}
  $scope.preview = ->
    $http.post "/preview",
        $.param({ "body": $scope.data.body }),
        headers:
          "Content-Type": 'application/x-www-form-urlencoded'
    .success (data, status, headers) ->
      $scope.data.preview = data
