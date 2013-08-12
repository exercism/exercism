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