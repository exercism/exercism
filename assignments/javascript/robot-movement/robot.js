var Robot = function () {
  xAxis = 0;
  yAxis = 0;
  this.coordinates = [xAxis,yAxis];
  this.bearing = 'north';
};

Robot.prototype.at = function(xcoord,ycoord) {
 this.coordinates = [xcoord, ycoord];
};

Robot.prototype.orient = function (direction) {
  this.bearing = direction;
  return "The robot is pointed " + direction;
};

Robot.prototype.advance = function() {

  if (this.bearing == 'north')
  {
    this.coordinates = [xAxis, yAxis + 1];
  }
  else if (this.bearing == 'south')
  {
    this.coordinates = [xAxis, yAxis - 1];
  }
  else if (this.bearing == 'east')
  {
    this.coordinates = [xAxis + 1, yAxis];
  }
  else if(this.bearing == 'west')
  {
    this.coordinates = [xAxis -1, yAxis];
  }
};

Robot.prototype.turnLeft = function() {

  if (this.bearing == 'north')
  {
    this.orient('west');
  }
  else if (this.bearing == 'south')
  {
    this.orient('east');
  }
  else if (this.bearing == 'east')
  {
    this.orient('north');
  }
  else if (this.bearing == 'west')
  {
    this.orient('south');
  }
};

Robot.prototype.turnRight = function() {

  if (this.bearing == 'north')
  {
    this.orient('east');
  }
  else if (this.bearing == 'south')
  {
    this.orient('west');
  }
  else if (this.bearing == 'east')
  {
    this.orient('south');
  }
  else if(this.bearing == 'west')
  {
    this.orient('north');
  }
};