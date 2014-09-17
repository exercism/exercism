describe "PaginationCtrl", ->
  beforeEach ->
    module("exercism")

  beforeEach inject ($controller, $rootScope, $httpBackend) ->
    @$httpBackend = $httpBackend
    @scope = $rootScope.$new()
    @$httpBackend.whenGET("/api/v1/looks").respond({ looks: ['LOOKS'] })
    $controller('PaginationCtrl', { $scope: @scope })
    @$httpBackend.flush()

  afterEach ->
    @$httpBackend.verifyNoOutstandingRequest()
    @$httpBackend.verifyNoOutstandingExpectation()

  it "currentPage should default to 0", ->
    expect(@scope.currentPage).toEqual(0)

  it "pageSize should default to 10", ->
    expect(@scope.pageSize).toEqual(10)

  it "should get the looks", ->
    expect(@scope.looks).toEqual(['LOOKS'])

  it "should calculate the number of pages", ->
    expect(@scope.numberOfPages()).toEqual(1)


describe "startFrom", ->
  beforeEach ->
    module("exercism")

  it "should filter from startFrom", inject ($filter) ->
    filter = $filter("startFrom")
    expect(filter([1, 2, 3], 2)).toEqual([3])
