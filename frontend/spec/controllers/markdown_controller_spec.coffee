describe "MarkdownCtrl", ->
  beforeEach ->
    module("exercism")

  beforeEach inject ($controller, $rootScope, $httpBackend) ->
    this.$httpBackend = $httpBackend
    this.scope = $rootScope.$new()
    $controller('MarkdownCtrl', { $scope: this.scope })

  afterEach ->
    @$httpBackend.verifyNoOutstandingRequest()
    @$httpBackend.verifyNoOutstandingExpectation()

  it "data should be set", ->
    expect(this.scope.data).toEqual({})

  describe "preview function", ->
    it "posts to preview with comment", ->
      @scope.data.body = "testcomment"
      @$httpBackend.expectPOST("/preview", "body=testcomment").respond(200, '')
      @scope.preview()
      @$httpBackend.flush()
    it "posts to preview with correct content type", ->
      @$httpBackend.expectPOST("/preview",
        undefined, (headers) ->
          headers["Content-Type"].indexOf("form-urlencoded") != -1
      ).respond(200, "")
      @scope.preview()
      @$httpBackend.flush()
    it "assigns successfull response to preview", ->
      @$httpBackend.expectPOST("/preview",
        undefined).respond(200, "test_response")
      @scope.preview()
      @$httpBackend.flush()
      expect(@scope.data.preview).toEqual("test_response")


