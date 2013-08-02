class NucleicAcid
  THYMIDINE = 'T'
  URACIL = 'U'

  attr_reader :strand
  def initialize(strand)
    @strand = strand
  end

  require 'forwardable'
  extend Forwardable
  def_delegators :strand, :to_str, :to_s, :==
end

class RibonucleicAcid < NucleicAcid
end

class DeoxyribonucleicAcid < NucleicAcid
  def to_rna
    RibonucleicAcid.new(strand.tr THYMIDINE, URACIL)
  end
end
