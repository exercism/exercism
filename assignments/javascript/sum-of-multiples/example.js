'use strict';

function isMultiple(i) {
  /*jshint validthis:true */
  var result = false;
  this.multiples.forEach(function (multiple) {
    if (i % multiple === 0) { result = true; }
  });
  return result;
}

function SumOfMultiples(multiples) {
  if (!(this instanceof SumOfMultiples)) {
    if (multiples === undefined) {
      return new SumOfMultiples([5, 3]);
    } else {
      return new SumOfMultiples(multiples);
    }
  }
  this.multiples = multiples;
}

SumOfMultiples.prototype.to = function (limit) {
  var sum = 0;
  for (var i = 1; i < limit; i++) {
    if (isMultiple.call(this, i)) { sum += i; }
  }
  return sum;
};

module.exports = SumOfMultiples;