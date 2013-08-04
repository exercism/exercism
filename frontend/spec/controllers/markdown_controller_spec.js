describe("works from js", function() {

  beforeEach(function() {
    module("exercism");
  });

  beforeEach(inject(function($controller, $rootScope, $httpBackend) {
    this.$httpBackend = $httpBackend;
    this.scope = $rootScope.$new();
    $controller('MarkdownCtrl', {
      $scope: this.scope,
    });
  }));

  afterEach(function() {
    this.$httpBackend.verifyNoOutstandingRequest();
    this.$httpBackend.verifyNoOutstandingExpectation();
  });



  it("data should be set", function() {
    expect(this.scope.data).toEqual({})
  });
});
