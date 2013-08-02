# In general, inheriting from Ruby core classes
# is dangerous and confusing.
# http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
# In this case it works out with few surprises.
class DNA < String
  THYMIDINE = 'T'
  URACIL = 'U'

  def to_rna
    RNA.new(tr THYMIDINE, URACIL)
  end
end
RNA = DNA

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

# DNA = DeoxyribonucleicAcid
# RNA = RibonucleicAcid
