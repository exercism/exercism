class Hamming
  def self.compute(strand1, strand2)
    (0...[strand1.length, strand2.length].min).count do |i|
      strand1[i] != strand2[i]
    end
  end
end
