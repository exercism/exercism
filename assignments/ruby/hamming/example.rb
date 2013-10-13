class Hamming
  def self.compute(strand1, strand2)
    strand1.chars.zip(strand2.chars).select do |a, b|
      mutation?(a, b)
    end.count
  end

  def self.mutation?(a, b)
    (a && b) && (a != b)
  end
end
