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
      @$httpBackend.expectPOST("/comments/preview", "body=testcomment").respond(200, '')
      @scope.preview()
      @$httpBackend.flush()
    it "posts to preview with correct content type", ->
      @$httpBackend.expectPOST("/comments/preview",
        undefined, (headers) ->
          headers["Content-Type"].indexOf("form-urlencoded") != -1
      ).respond(200, "")
      @scope.preview()
      @$httpBackend.flush()
    it "assigns successfull response to preview", ->
      @$httpBackend.expectPOST("/comments/preview",
        undefined).respond(200, "test_response")
      @scope.preview()
      @$httpBackend.flush()
      expect(@scope.data.preview).toEqual("test_response")

  describe "mentioning a user", ->
    it "gets a list of matching users from the backend", ->
      @$httpBackend.expectGET("/api/v1/user/find?query=al").respond(200, JSON.stringify(['alice']))
      spy = spyOn($.fn, 'atwho')
      @scope.data.body = '@al'
      @scope.$digest()
      @$httpBackend.flush()
      expect(spy).toHaveBeenCalledWith({
        at: '@',
        data: ['alice']
      })

