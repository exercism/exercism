class DNA

  attr_reader :strand
  def initialize(strand)
    @strand = strand
  end

  def to_rna
    strand.gsub('T', 'U')
  end

end
