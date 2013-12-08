var Squares = require('./difference-of-squares');

describe('Squares', function () {

  describe('up to 5', function () {
    var squares = new Squares(5);

    it('gets the square of sums', function () {
      expect(squares.squareOfSums).toBe(225);
    });

    xit('gets the sum of squares', function () {
      expect(squares.sumOfSquares).toBe(55);
    });

    xit('gets the difference', function () {
      expect(squares.difference).toBe(170);
    });

  });

  describe('up to 10', function () {
    var squares = new Squares(10);

    xit('gets the square of sums', function () {
      expect(squares.squareOfSums).toBe(3025);
    });

    xit('gets the sum of squares', function () {
      expect(squares.sumOfSquares).toBe(385);
    });

    xit('gets the difference', function () {
      expect(squares.difference).toBe(2640);
    });

  });

  describe('up to 100', function () {
    var squares = new Squares(100);

    xit('gets the square of sums', function () {
      expect(squares.squareOfSums).toBe(25502500);
    });

    xit('gets the sum of squares', function () {
      expect(squares.sumOfSquares).toBe(338350);
    });

    xit('gets the difference', function () {
      expect(squares.difference).toBe(25164150);
    });

  });

});
