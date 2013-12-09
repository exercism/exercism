'use strict';

module.exports = function (input) {
  var counts = {};
  var tokens = String(input).match(/\b[a-z0-9]+\b/gi) || [];

  tokens.forEach(function (token) {
    var word = token.toLowerCase();
    word in counts ? counts[word] += 1 : counts[word] =  1;
  });

  return counts;
};
