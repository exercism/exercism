'use strict';

module.exports = function Squares(max) {
  return {
    get squareOfSums() {
      var sum = 0;
      for (var x = 1; x <= max; x++) {
        sum += x;
      }
      return sum*sum;
    },
    get sumOfSquares() {
      var sum = 0;
      for (var x = 1; x <= max; x++) {
        sum += x*x;
      }
      return sum;
    },
    get difference() {
      return this.squareOfSums - this.sumOfSquares;
    }
  };
};