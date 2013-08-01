(function () {
  'use strict';

  function Grains() {}

  Grains.prototype.square = function (n) {
    return Math.pow(2, n - 1);
  };

  Grains.prototype.total = function () {
    var n, total = 0;

    for (n = 1; n <= 64; n++) {
      total += this.square(n);
    }

    return total;
  };

  module.exports = Grains;
})();