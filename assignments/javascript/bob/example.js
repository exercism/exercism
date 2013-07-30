function Bob() {
  'use strict';

  function isSilence(message) {
    return message === "";
  }

  function isShouting(message) {
    return message.toUpperCase() === message;
  }

  function isAQuestion(message) {
    return message[message.length - 1] === "?";
  }

  this.hey = function(message) {
    if (isSilence(message)) {
      return "Fine, be that way!";
    } else if (isShouting(message)) {
      return "Woah, chill out!";
    } else if (isAQuestion(message)) {
      return "Sure.";
    } else {
      return 'Whatever.';
    }
  };
}

module.exports = Bob;
