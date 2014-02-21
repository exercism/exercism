'use strict';

module.exports = function (input) {
  var counts = Object.create(null);
  var tokens = String(input).match(/\b[a-z0-9]+\b/gi) || [];

  tokens.forEach(function (token) {
    var word = token.toLowerCase();
    counts[word] = counts[word] ? counts[word] + 1 : 1;
  });

  return counts;
};
