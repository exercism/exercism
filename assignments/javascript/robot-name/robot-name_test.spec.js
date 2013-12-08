var Robot = require('./robot-name');

describe("Robot", function() {
  it("has a name", function() {
    var robot = new Robot();
    expect(robot.name).toMatch(/\w{2}\d{3}/);
  });

  xit("name is the same each time", function() {
    var robot = new Robot();
    expect(robot.name).toEqual(robot.name);
  });

  xit("different robots have different names", function() {
    var robotOne = new Robot();
    var robotTwo = new Robot();
    expect(robotOne.name).not.toEqual(robotTwo.name);
  });

  xit("is able to reset the name", function() {
    var robot = new Robot();
    var originalName = robot.name;
    robot.reset();
    var newName = robot.name;
    expect(originalName).not.toEqual(newName);
  });
});
