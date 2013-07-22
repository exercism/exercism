class DNA

  attr_reader :strand
  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(other_strand)
    strand.chars.zip(other_strand.chars).count do |a, b|
      b && a != b
    end
  end
end
