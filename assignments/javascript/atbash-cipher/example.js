'use strict';

var LETTERS = 'abcdefghijklmnopqrstuvwxyz';
var REVERSED_LETTERS = 'zyxwvutsrqponmlkjihgfedcba';

function insertSpacing(s, interval) {
  var matcher = new RegExp(".{1," + interval + "}", "g");
  return s.match(matcher).join(' ');
}

function invert(character) {
  /*jshint validthis: true */
  if (character.match(/\d/)) {
    this.push(character);
  } else {
    this.push(LETTERS[REVERSED_LETTERS.indexOf(character)]);
  }
}

module.exports = {
  encode: function (s) {
    var encoded = '';
    var characters = [];
    s.toLowerCase().split('').forEach( invert, characters );
    encoded = insertSpacing(characters.join(''), 5);
    return encoded;
  }
};