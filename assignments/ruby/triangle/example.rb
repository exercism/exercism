class TriangleError < RuntimeError
end

class Triangle

  attr_reader :a, :b, :c
  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def kind
    raise TriangleError if illegal?
    if equilateral?
      :equilateral
    elsif isosceles?
      :isosceles
    else
      :scalene
    end
  end

  private

  def sides
    @sides ||= [a, b, c]
  end

  def equilateral?
    sides.uniq.size == 1
  end

  def isosceles?
    sides.uniq.size == 2
  end

  def illegal?
    impossible_length_side? || violates_inequality?
  end

  def violates_inequality?
    a + b <= c || a + c <= b || b + c <= a
  end

  def impossible_length_side?
    sides.any? { |side| side <= 0 }
  end
end
