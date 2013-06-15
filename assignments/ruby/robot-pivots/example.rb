class Robot

  attr_accessor :bearing

  def orient(direction)
    unless compass.include?(direction)
      raise ArgumentError
    end
    self.bearing = direction
  end

  def turn_right
    rotate(:+)
  end

  def turn_left
    rotate(:-)
  end

  private

  def rotate(sign)
    i = compass.index(bearing)
    self.bearing = compass[i.send(sign, 1) % 4]
  end

  def compass
    [:north, :east, :south, :west]
  end

end
