describe "works from js", ->
  beforeEach ->
    module("exercism")

  beforeEach inject ($controller, $rootScope, $httpBackend) ->
    this.$httpBackend = $httpBackend
    this.scope = $rootScope.$new()
    $controller('MarkdownCtrl', { $scope: this.scope })

  afterEach ->
    this.$httpBackend.verifyNoOutstandingRequest()
    this.$httpBackend.verifyNoOutstandingExpectation()

  it "data should be set", ->
    expect(this.scope.data).toEqual({})
