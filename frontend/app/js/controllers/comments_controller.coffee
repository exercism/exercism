angular.module('exercism').controller "CommentsCtrl", ($scope, $http) ->
  $scope.commentThread   = {}
  $scope.hideCommentForm = true

  $scope.showCommentForm = ->
    $scope.hideCommentForm = false

  $scope.hideCommentFormFn = ->
    $scope.hideCommentForm = true

  $scope.addComment = (commentId)->
    commentThreadBody = $scope.commentThread.body

    $http.post "/comments/#{commentId}/comment_threads",
      $.param({ "body": commentThreadBody }),
      headers:
        "Content-Type": 'application/x-www-form-urlencoded'
    .success (data, status, headers) ->
      $scope.commentThreads.push(data)
      $scope.hideCommentForm = true
      $scope.commentThread.body = ''
    .error (data, status, headers) ->
      alert(data.body)
