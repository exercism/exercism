class DNA

  attr_reader :nucleotides
  def initialize(strand)
    @nucleotides = strand.chars
  end

  def count(abbreviation)
    validate!(abbreviation)
    nucleotides.count(abbreviation)
  end

  def nucleotide_counts
    {
      'A' => count('A'),
      'T' => count('T'),
      'G' => count('G'),
      'C' => count('C')
    }
  end

  def validate!(abbreviation)
    unless nucleotide?(abbreviation)
      raise ArgumentError.new("#{abbreviation} is not a nucleotide.")
    end
  end

  def nucleotide?(abbreviation)
    %w(A T C G U).include?(abbreviation)
  end

end
