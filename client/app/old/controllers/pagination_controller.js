!function() {
  module.exports = function(ngModule) {
    ngModule.controller("PaginationCtrl", function($scope, $http) {
      $scope.currentPage = 0;
      $scope.pageSize = 10;
      $scope.looks = [];
      $http.get("/api/v1/looks").success(function(data, status, headers) {
        return $scope.looks = data.looks;
      });
      $scope.numberOfPages = function() {
        return Math.ceil($scope.looks.length / $scope.pageSize);
      };
      return this;
    });

    angular.module('exercism').filter('startFrom', function() {
      return function(input, start) {
        start = +start;
        return input.slice(start);
      };
    });
  };
}(this);
