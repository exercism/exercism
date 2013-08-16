'use strict';

var BASE = 8;

function Octal(octal) {
  this.digits = octal.split('').reverse().map(Number);
}

Octal.prototype.toDecimal = function() {
  var decimal = this.digits.reduce(this.accumulator, 0);
  return isNaN(decimal) ? 0 : decimal;
};

Octal.prototype.accumulator = function(decimal, digit, index) {
  return decimal += digit * Math.pow(BASE, index);
};

module.exports = Octal;