class Hamming
  def self.compute(strand1, strand2)
    new(strand1, strand2).distance
  end

  attr_reader :strand1, :strand2
  def initialize(strand1, strand2)
    @strand1 = strand1
    @strand2 = strand2
  end

  def distance
    common_pairs.count do |pair|
      mutation?(*pair)
    end
  end

  private

  def common_pairs
    sequence1.chars.zip(sequence2.chars)
  end

  def sequence1
    strand1[0..common_length]
  end

  def sequence2
    strand2[0..common_length]
  end

  def common_length
    [@strand1.length, @strand2.length].min - 1
  end

  def mutation?(a, b)
    a != b
  end
end
