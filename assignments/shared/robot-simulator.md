## Step 1

The robot factory manufactures robots that have three possible movements:

* turn right
* turn left
* advance

Robots are placed on a hypothetical, infinite grid, facing a particular
direction (north, east, south, west) at a set of {x,y} coordinates, e.g.
`[3,8]`.

## Step 2

Robots can pivot left and right.

The robot factory manufactures robots that have three possible movements:

* turn right
* turn left
* advance

The factory's test facility needs a program to verify robot movements.

There are a number of different rooms of varying sizes, measured in Robot
Units, the distance a robot moves when you instruct it to `advance`.

The floor of the room is a grid, each square of which measures 1 square RU
(Robot Unit).

The rooms are always oriented so that each wall faces east, south, west, and
north.

The test algorithm is to place a robot at a coordinate in the room, facing in a particular direction.

The robot then receives a number of instructions, at which point the testing
facility verifies the robot's new position, and in which direction it is
pointing.

## Step 3

The robot factory manufactures robots that have three possible movements:

* turn right
* turn left
* advance

The robot factory's test facility has a simulator which can take a string of
letters and feed this into a robot as instructions.

```ruby
simulator = Simulator.new
robot = Robot.new
simulator.place(robot, x: 7, y: 3, direction: :north)
simulator.instructions("RAALAL")
=> [:turn_right, :advance, :advance, :turn_left, :advance, :turn_left]
simulator.evaluate(robot, "RLAALAL")
robot.coordinates
# => [9, 4]
robot.bearing
# => :west
```
