(function() {
  'use strict';

  function Anagram(word) {
    this.word = word.toLowerCase();
  }

  Anagram.prototype.match = function(words) {
    var matches = [];

    for(var i = 0; i < words.length; i++) {
      var currentWord = words[i];

      if (currentWord.length == this.word.length && currentWord.toLowerCase() != this.word) {
        var currentWordLetters = currentWord.toLowerCase().split('').sort();
        var matchingWordLetters = this.word.split('').sort();

        var isMatch = true;

        for (var j = 0; j < currentWordLetters.length; j++) {
          if (currentWordLetters[j] != matchingWordLetters[j]) {
            isMatch = false;
          }
        }

        if (isMatch) { matches.push(currentWord); }
      }

    }
    return matches;
  };

  module.exports = Anagram;
})();
