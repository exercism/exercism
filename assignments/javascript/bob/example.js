Bob = function() {

  this.hey = function(message) {
    if (this.isSilence(message)) {
      return "Fine, be that way.";
    } else if (this.isShouting(message)) {
      return "Woah, chill out!";
    } else if (this.isAQuestion(message)) {
      return "Sure";
    } else {
      return 'Whatever';
    }
  };

  this.isSilence = function(message) {
    return message === "";
  }

  this.isShouting = function(message) {
    return message.toUpperCase() === message;
  }

  this.isAQuestion = function(message) {
    return message[message.length -1] === "?";
  }
};

