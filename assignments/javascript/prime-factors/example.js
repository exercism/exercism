'use strict';

exports.for = function (n) {
  var prime_factors = [];
  var possible_factor = 2;
  while (possible_factor * possible_factor <= n) {
    while (n % possible_factor === 0) {
      prime_factors.push(possible_factor);
      n /= possible_factor;
    }
    possible_factor += 1;
  }
  if (n > 1) { prime_factors.push(n); }
  return prime_factors;
};