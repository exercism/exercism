class Year

  attr_reader :year
  def initialize(number)
    @year = number.to_i
  end

  def leap?
    by4 && (!by100 || by400)
  end

  private

  def by4
    (year % 4) == 0
  end

  def by100
    (year % 100) == 0
  end

  def by400
    (year % 400) == 0
  end

end

class Fixnum
  def leap_year?
    Year.new(self).leap?
  end
end
