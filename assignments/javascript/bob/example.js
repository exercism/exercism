function Bob() {
  'use strict';

  function isSilence(message) {
    return message.replace(/\s+/g, '') === "";
  }

  function isShouting(message) {
    return message.toUpperCase() === message && /[A-Z]/.test(message);
  }

  function isAQuestion(message) {
    return message[message.length - 1] === "?";
  }

  this.hey = function(message) {
    if (isSilence(message)) {
      return "Fine. Be that way!";
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


//Another approach for Bob example.
var Bob = function(){
    this.regexes = ["^$|^ +$", "(?=.*[A-Z])^[^a-z\xE0-\xFF]+$", ".[?]$"];
    this.response = ['Fine. Be that way!', 'Woah, chill out!', 'Sure.'];
};

Bob.prototype.hey = function (text) {
    for (var i in this.regexes) {
        if (text.match(new RegExp(this.regexes[i]))) {
            return this.response[i];
        }
    }
    return 'Whatever.';
};

module.exports = Bob;
