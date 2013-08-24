'use strict';

module.exports = Triplet;

function Triplet(a, b, c) {
  this.a = a;
  this.b = b;
  this.c = c;
}

function Triplets(conditions) {
  this.min = conditions.minFactor || 1;
  this.max = conditions.maxFactor;
  this.sum = conditions.sum;
}

Triplet.prototype.isPythagorean = function () {
  return this.a*this.a + this.b*this.b === this.c*this.c;
};

Triplet.prototype.product = function () {
  return this.a * this.b * this.c;
};

Triplet.prototype.sum = function () {
  return this.a + this.b + this.c;
};

Triplet.where = function (conditions) {
  return new Triplets(conditions).toArray();
};

Triplets.prototype.isDesired = function (triplet) {
  return triplet.isPythagorean() && (!this.sum || triplet.sum() === this.sum);
};

Triplets.prototype.toArray = function () {
  var triplet, triplets = [];
  for (var a = this.min; a < this.max - 1; a++) {
    for (var b = a + 1; b < this.max; b++) {
      for (var c = b + 1; c <= this.max; c++) {
        triplet = new Triplet(a, b, c);
        if (this.isDesired(triplet)) {
          triplets.push(triplet);
        }
      }
    }
  }
  return triplets;
};