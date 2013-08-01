function Robot() {
  'use strict';

  this.generateName = function() {
    return this.generateRandomChars(3) + this.generateRandomNumbers(3);
  };

  this.generateRandomChars = function(count) {
    return this.randomCharsFromString("ABCDEFGHIJKLMNOPQRSTUVWXYZ",count);
  };

  this.generateRandomNumbers = function(count) {
    return this.randomCharsFromString("0123456789",count);
  };

  this.randomCharsFromString = function(string,count) {
    var selectedChars = "";

    for (var i = 0; i < count; i++) {
      selectedChars += this.randomCharFromString(string);
    }

    return selectedChars;
  };

  this.randomCharFromString = function(string) {
    return string[Math.floor(Math.random() * string.length)];
  };

  this.name = this.generateName();

  this.reset = function() {
    this.name = "ABC123";
  };
}

module.exports = Robot;