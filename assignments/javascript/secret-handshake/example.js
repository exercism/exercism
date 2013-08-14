'use strict';

function SecretHandshake(handshake) {
  SecretHandshake.allCommands = [ "wink", "double blink", "close your eyes", "jump", "REVERSE" ];
  var handshakeCommands = SecretHandshake.allCommands;

  if (typeof handshake !== 'number') {
    throw new Error("Handshake must be a number");
  }

  this.commands = function() {
    return this.shakeWith;
  };

  this.calculateHandshake = function(handshake) {
    /*jshint bitwise:false */
    var shakeWith = [];

    for (var i = 0; i < handshakeCommands.length; i++) {
      var currentCommand = handshakeCommands[i];
      var handshakeHasCommand = (handshake & Math.pow(2,i));

      if (handshakeHasCommand) {
        if (currentCommand === "REVERSE") {
          shakeWith.reverse();
        } else {
          shakeWith.push(handshakeCommands[i]);
        }
      }
    }

    return shakeWith;
  };

  this.shakeWith = this.calculateHandshake(handshake);

}

module.exports = SecretHandshake;