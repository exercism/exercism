'use strict';

module.exports = {
  translate: function (english) {
    var words = english.split(' ');
    var translated = [];

    function translateWord(word) {
      var parts = word.match(/^([^aeiou]?qu|[^aeiou]*)(.+)/);
      var beginning = parts[1];
      var ending = parts[2];

      if (beginning.length === 0) {
        translated.push(word + 'ay');
      } else {
        translated.push(ending + beginning + 'ay');
      }
    }

    words.forEach( translateWord );
    return translated.join(' ');
  }
};