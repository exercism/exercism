package rnatranscription

import "strings"

func ToRna(dna string) string{
  return strings.Replace(dna, "T", "U", -1)
}

/*

# In general, inheriting from Ruby core classes
# is dangerous and confusing.
# http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
# In this case it works out with no surprises.
class DNA < String
  THYMIDINE = 'T'
  URACIL = 'U'

  def to_rna
    tr THYMIDINE, URACIL
  end
end

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

*/