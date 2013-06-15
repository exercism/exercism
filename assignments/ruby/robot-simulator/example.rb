class Simulator

  def instructions(text)
    text.split("").map {|char| command(char)}
  end

  def place(robot, position)
    robot.at(position[:x], position[:y])
    robot.orient(position[:direction])
  end

  def evaluate(robot, text)
    instructions(text).each do |command|
      robot.send(command)
    end
  end

  private

  def command(char)
    {
      'R' => :turn_right,
      'L' => :turn_left,
      'A' => :advance
    }[char]
  end

end

class Robot

  attr_accessor :x, :y, :bearing

  def at(x, y)
    self.x = x
    self.y = y
  end

  def coordinates
    [x, y]
  end

  def orient(direction)
    unless cardinal_directions.include?(direction)
      raise ArgumentError
    end
    self.bearing = direction
  end

  def advance
    if bearing == :north
      self.y += 1
    elsif bearing == :south
      self.y -= 1
    elsif bearing == :west
      self.x -= 1
    else
      self.x += 1
    end
  end

  def turn_right
    turn(:+)
  end

  def turn_left
    turn(:-)
  end

  private

  def turn(sign)
    i = cardinal_directions.index(bearing)
    self.bearing = cardinal_directions[i.send(sign, 1) % 4]
  end

  def cardinal_directions
    [:north, :east, :south, :west]
  end

end
