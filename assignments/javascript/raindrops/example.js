'use strict';

function Raindrops() {}

Raindrops.prototype.convert = function (n) {
  var result = "";
  if (n % 3 === 0) { result += 'Pling'; }
  if (n % 5 === 0) { result += 'Plang'; }
  if (n % 7 === 0) { result += 'Plong'; }
  if (result === '') {
    return n.toString();
  } else {
    return result;
  }
};

module.exports = Raindrops;