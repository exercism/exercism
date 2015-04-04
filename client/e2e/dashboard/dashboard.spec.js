describe('exercism', function() {

  beforeEach(function() {
    browser.get('/');
  })

  describe('dashboard', function() {
    it('should display the correct title', function() {
      expect(browser.getTitle()).toBe('exercism.io');
    });
  });
});
