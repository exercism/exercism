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
