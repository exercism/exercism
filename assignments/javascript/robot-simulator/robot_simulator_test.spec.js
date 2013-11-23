Robot = require('./robot');

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

  xit("robot coordinates", function() {
    robot.at(3, 0);
    expect(robot.coordinates).toEqual([3,0]);
  });


  xit("other robot coordinates", function() {
    robot.at(-2, 5);
    expect(robot.coordinates).toEqual([-2,5]);
  });

  xit("advance when facing north", function() {
    robot.at(0,0);
    robot.orient('north');
    robot.advance();
    expect(robot.coordinates).toEqual([0,1]);
  });

  xit("advance when facing east", function() {
    robot.at(0,0);
    robot.orient('east');
    robot.advance();
    expect(robot.coordinates).toEqual([1,0]);
  });

  xit("advance when facing south", function() {
    robot.at(0,0);
    robot.orient('south');
    robot.advance();
    expect(robot.coordinates).toEqual([0,-1]);
  });

  xit("advance when facing west", function() {
    robot.at(0,0);
    robot.orient('west');
    robot.advance();
    expect(robot.coordinates).toEqual([-1,0]);
  });

  xit("instructions for turning left", function() {
    expect(robot.instructions("L")).toEqual(["turnLeft"]);
  });

  xit("instructions for turning right", function() {
    expect(robot.instructions("R")).toEqual(["turnRight"]);
  });

  xit("instructions for advancing", function() {
    expect(robot.instructions("A")).toEqual(["advance"]);
  });

  xit("series of instructions", function() {
    expect(robot.instructions("RAAL"))
      .toEqual(["turnRight", "advance", "advance", "turnLeft"]);
  })

  xit("instruct robot", function() {
    robot.place({x: -2, y: 1, direction: "east"});
    robot.evaluate("RLAALAL")
    expect(robot.coordinates).toEqual([0,2]);
    expect(robot.bearing).toEqual("west");
  });

  xit("instruct many robots", function() {
    var robot1 = new Robot
    var robot2 = new Robot
    var robot3 = new Robot
    robot1.place({x: 0, y: 0, direction: "north"});
    robot2.place({x: 2, y: -7, direction: "east"});
    robot3.place({x: 8, y: 4, direction: "south"});
    robot1.evaluate("LAAARALA");
    robot2.evaluate("RRAAAAALA");
    robot3.evaluate("LAAARRRALLLL");

    expect(robot1.coordinates).toEqual([-4, 1]);
    expect(robot1.bearing).toEqual("west");

    expect(robot2.coordinates).toEqual([-3, -8]);
    expect(robot2.bearing).toEqual("south");

    expect(robot3.coordinates).toEqual([11, 5]);
    expect(robot3.bearing).toEqual("north");
  });

});