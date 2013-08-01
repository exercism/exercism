function Triangle(a,b,c) {
  'use strict';

  this.sides = [ a, b, c ];

  this.kind = function() {
    var name = "scalene";

    if (this.isIllegal()) {
      name = "illegal";
    } else if (this.isEquilateral()) {
      name = "equilateral";
    } else if (this.isIsosceles()) {
      name = "isosceles";
    }

    return name;
  };

  this.isIllegal = function() {
    return this.violatesInequality() || this.hasImpossibleSides();
  };

  this.violatesInequality = function() {
    var a = this.sides[0], b = this.sides[1], c = this.sides[2];
    return (a + b <= c) || (a + c <= b) || (b + c <= a);
  };

  this.hasImpossibleSides = function() {
    return this.sides[0] <= 0 || this.sides[1] <= 0 || this.sides[2] <= 0;
  };

  this.isEquilateral = function() {
    return this.uniqueSides().length === 1;
  };

  this.isIsosceles = function() {
    return this.uniqueSides().length === 2;
  };

  this.uniqueSides = function() {
    var sides = this.sides;
    var uniques = {};

    for (var i = 0; i < sides.length; i++) {
      var currentSide = sides[i];
      uniques[currentSide] = true;
    }

    var uniqueSides = [];

    for (var uniqueSide in uniques) {
      uniqueSides.push(uniqueSide);
    }

    return uniqueSides;
  };
}

module.exports = Triangle;