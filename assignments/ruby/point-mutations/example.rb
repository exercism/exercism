class DNA

  attr_reader :strand
  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(other_strand)
    strand.chars.zip(other_strand.chars).reject do |a, b|
      a == b || b.nil?
    end.size
  end
end
