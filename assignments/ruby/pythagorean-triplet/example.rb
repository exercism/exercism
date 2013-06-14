class Triplets

  attr_reader :factors, :sum
  def initialize(conditions)
    min = conditions.fetch(:min_factor) { 1 }
    max = conditions.fetch(:max_factor)
    @sum = conditions[:sum]
    @factors = (min..max).to_a
  end

  def to_a
    triplets = []
    each_triplet do |triplet|
      triplets << triplet if select?(triplet)
    end
    triplets
  end

  def each_triplet
    factors.combination(3).each do |a, b, c|
      yield Triplet.new(a, b, c)
    end
  end

  def select?(triplet)
    triplet.pythagorean? && (!sum || triplet.sum == sum)
  end
end

class Triplet

  def self.where(conditions)
    Triplets.new(conditions).to_a
  end

  attr_reader :a, :b, :c
  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def sum
    a + b + c
  end

  def product
    a * b * c
  end

  def pythagorean?
    a**2 + b**2 == c**2
  end
end

