angular.module('exercism').controller "PaginationCtrl", ($scope, $http) ->
  $scope.currentPage = 0
  $scope.pageSize = 10
  $scope.looks = []
  $http.get("/api/v1/looks")
  .success (data, status, headers) ->
    $scope.looks = data.looks

  $scope.numberOfPages = ->
    return Math.ceil($scope.looks.length/$scope.pageSize)
  this

angular.module('exercism').filter 'startFrom', ->
  return (input, start) ->
    # parse to int
    start = +start
    input.slice(start)
