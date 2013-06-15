class SumOfMultiples

  def self.to(limit)
    new(5, 3).to(limit)
  end

  attr_reader :multiples
  def initialize(*multiples)
    @multiples = multiples
  end

  def to(limit)
    sum = 0
    (1...limit).each do |i|
      sum += i if multiple?(i)
    end
    sum
  end

  private

  def multiple?(i)
    multiples.any? do |multiple|
      i % multiple == 0
    end
  end

end

