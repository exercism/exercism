function Words(input) {
  'use strict';

  var words = input.match(/\b[a-z0-9]+\b/gi);
  var counts = {};

  for (var i = 0; i < words.length; i++) {
    var currentWord = words[i].toLowerCase();

    if (counts[currentWord] === undefined) {
      counts[currentWord] = 0;
    }

    counts[currentWord] += 1;

  }

  this.count = counts;
}

module.exports = Words;