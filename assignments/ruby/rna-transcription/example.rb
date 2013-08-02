class DeoxyribonucleicAcid
  THYMIDINE = 'T'
  URACIL = 'U'

  attr_reader :strand
  def initialize(strand)
    @strand = strand
  end

  def to_rna
    strand.tr THYMIDINE, URACIL
  end
end

