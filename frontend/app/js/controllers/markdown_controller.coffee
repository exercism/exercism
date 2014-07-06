angular.module('exercism').controller "MarkdownCtrl", ($scope, $http) ->
  PATTERN = /\B@[a-z0-9_-]+/gi

  $scope.data ||= {}

  $scope.$watch 'data.body', (body) ->
    if body && PATTERN.test(body)
      query = body.match(PATTERN)[0].replace('@', '')
      $http.post "/api/v1/user/find",
          $.param({ "query": query }),
          headers:
            "Content-Type": 'application/x-www-form-urlencoded'
      .success (data, status, headers) ->
        $('.comment').atwho({
          at: '@',
          data: data
        })

  $scope.preview = ->
    $http.post "/comments/preview",
        $.param({ "body": $scope.data.body }),
        headers:
          "Content-Type": 'application/x-www-form-urlencoded'
    .success (data, status, headers) ->
      $scope.data.preview = data
