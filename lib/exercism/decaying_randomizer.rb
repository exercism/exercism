class DecayingRandomizer

  def initialize(upper)
    @upper = upper
  end

  def next
    (transposed * upper).to_i
  end

  private
  attr_reader :upper

  def transposed
    (normal - 0.5).abs * 2
  end

  def normal
    4.times.collect { rand }.reduce(:+) / 4
  end

end
