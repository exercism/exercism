'use strict';

function Hexadecimal(hex) {
  this.hex = hex;

  this.toDecimal = function() {
    var hexCharacters = this.hex.split("");

    for (var i = 0; i < hexCharacters.length; i++) {
      if (/[^0-9a-fA-F]/.exec(hexCharacters[i])) { return 0; }
    }

    return parseInt(this.hex,16);
  };
}

module.exports = Hexadecimal;