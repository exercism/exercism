'use strict';

module.exports = Binary;

function Binary(binary) {
  this.binary = parseInt(binary, 2);
}

Binary.prototype.toDecimal = function () {
  var out = Number(this.binary.toString(10));
  return isNaN(out) ? 0 : out;
};
