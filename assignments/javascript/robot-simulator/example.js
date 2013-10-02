'use strict';

var Robot = function () {
  this.coordinates = [0, 0];
  this.bearing = 'north';
};

Robot.prototype.at = function (xcoord, ycoord) {
  this.coordinates = [xcoord, ycoord];
};

Robot.prototype.orient = function (direction) {
  this.bearing = direction;
  return "The robot is pointed " + direction;
};

Robot.prototype.advance = function () {

  if (this.bearing === 'north') {
    this.coordinates[1] += 1;
  } else if (this.bearing === 'south') {
    this.coordinates[1] -= 1;
  } else if (this.bearing === 'east') {
    this.coordinates[0] += 1;
  } else if (this.bearing === 'west') {
    this.coordinates[0] -= 1;
  }
};

Robot.prototype.turnLeft = function () {

  if (this.bearing === 'north') {
    this.orient('west');
  } else if (this.bearing === 'south') {
    this.orient('east');
  } else if (this.bearing === 'east') {
    this.orient('north');
  } else if (this.bearing === 'west') {
    this.orient('south');
  }
};

Robot.prototype.turnRight = function () {

  if (this.bearing === 'north') {
    this.orient('east');
  } else if (this.bearing === 'south') {
    this.orient('west');
  } else if (this.bearing === 'east') {
    this.orient('south');
  } else if (this.bearing === 'west') {
    this.orient('north');
  }
};

Robot.prototype.instructions = function (s) {
  var result = [];
  s.split('').forEach(function (character) {
    if (character === 'L') {
      result.push('turnLeft');
    } else if (character === 'R') {
      result.push('turnRight');
    } else if (character === 'A') {
      result.push('advance');
    }
  });
  return result;
};

Robot.prototype.place = function (args) {
  this.coordinates = [args.x, args.y];
  this.bearing = args.direction;
};

Robot.prototype.evaluate = function (s) {
  this.instructions(s).forEach(function (instruction) {
    this[instruction]();
  }, this);
};

module.exports = Robot;