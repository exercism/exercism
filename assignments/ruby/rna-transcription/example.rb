class DNA < String
  THYMIDINE = 'T'
  URACIL = 'U'

  def to_rna
    tr THYMIDINE, URACIL
  end
end

