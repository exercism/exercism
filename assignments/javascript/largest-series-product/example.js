'use strict';

function Series(numberString) {
  this.numberString = numberString;
  this.digits = this.getDigits();
}

Series.prototype.getDigits = function () {
  return this.numberString.split('').map(function (digit) {
    return parseInt(digit, 10);
  });
};

Series.prototype.largestProduct = function (size) {
  var product, max = 0;
  this.slices(size).forEach(function (slice) {
    product = slice.reduce(function(a, b) {
      return a*b;
    }, 1);
    if (product > max) { max = product; }
  });
  return max;
};

Series.prototype.slices = function (sliceSize) {
  var result = [];
  var slice = [];

  if (sliceSize > this.digits.length) {
    throw new Error('Slice size is too big.');
  }
  
  for (var i = 0; i < this.digits.length - sliceSize + 1; i++) {
    for (var j = 0; j < sliceSize; j++) {
      slice.push(this.digits[i+j]);
    }
    result.push(slice);
    slice =  [];
  }

  return result;
};

module.exports = Series;