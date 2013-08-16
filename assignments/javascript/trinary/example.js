'use strict';

module.exports = Trinary;

var BASE = 3;

function Trinary(decimal) {
  this.digits = decimal.split('').reverse().map(Number);
}

Trinary.prototype.toDecimal = function() {
  var decimal = this.digits.reduce(this.accumulator, 0);
  return isNaN(decimal) ? 0 : decimal;
};

Trinary.prototype.accumulator = function(decimal, digit, index) {
  return decimal += digit * Math.pow(BASE, index);
};
