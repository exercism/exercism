require('./robot');

describe("Robot", function() {
  var robot = new Robot();

  it("robot bearing", function() {
    var directions = [ 'east', 'west', 'north', 'south' ];

    for (var i = 0; i < directions.length; i++) {
      var currentDirection = directions[i];
      robot.orient(currentDirection)
      expect(robot.bearing).toEqual(currentDirection);
    };
  });

  xit("invalid robot bearing", function() {
    try {
      robot.orient("crood");
    } catch(exception) {
      expect(exception).toEqual("Invalid Robot Bearing")
    }
  });

  xit("turn right from north", function() {
    robot.orient('north');
    robot.turnRight();
    expect(robot.bearing).toEqual('east');
  });

  xit("turn right from east", function() {
    robot.orient('east');
    robot.turnRight();
    expect(robot.bearing).toEqual('south');
  });

  xit("turn right from south", function() {
    robot.orient('south');
    robot.turnRight();
    expect(robot.bearing).toEqual('west');
  });

  xit("turn right from west", function() {
    robot.orient('west');
    robot.turnRight();
    expect(robot.bearing).toEqual('north');
  });

  xit("turn left from north", function() {
    robot.orient('north');
    robot.turnLeft();
    expect(robot.bearing).toEqual('west');
  });

  xit("turn left from east", function() {
    robot.orient('east');
    robot.turnLeft();
    expect(robot.bearing).toEqual('north');
  });

  xit("turn left from south", function() {
    robot.orient('south');
    robot.turnLeft();
    expect(robot.bearing).toEqual('east');
  });

  xit("turn left from west", function() {
    robot.orient('west');
    robot.turnLeft();
    expect(robot.bearing).toEqual('south');
  });

});