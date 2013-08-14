'use strict';

module.exports = function(options) {
  if (options === undefined) {
    options = { white: [0,3], black: [7,3] };
  }

  if (options.white[0] === options.black[0] && options.white[1] === options.black[1]) {
    throw "Queens cannot share the same space";
  }

  this.white = options.white;
  this.black = options.black;

  this.canAttack = function() {
    var canAttack = false;

    if (this.white[0] === this.black[0]) {
      canAttack = true;
    }
    if (this.white[1] === this.black[1]) {
      canAttack = true;
    }

    var yDiagonal = this.white[0] - this.black[0];
    var xDiagonal = this.white[1] - this.black[1];

    if (xDiagonal === yDiagonal) {
      canAttack = true;
    }

    return canAttack;
  };

  this.boardRepresentation = function() {
    var boardRepresentation = "";

    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (this.white[0] === i && this.white[1] === j) {
          boardRepresentation += "W";
        } else if (this.black[0] === i && this.black[1] === j) {
          boardRepresentation += "B";
        } else {
          boardRepresentation += "O";
        }

        if (j < 7) { boardRepresentation += " "; }
      }
      boardRepresentation += "\n";
    }

    return boardRepresentation;
  };

  this.toString = function() {
    return this.boardRepresentation();
  };
};