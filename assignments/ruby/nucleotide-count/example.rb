class DNA

  attr_reader :strand
  def initialize(strand)
    @strand = strand
  end

  def count(nucleotide)
    unless valid_nucleotide?(nucleotide)
      raise ArgumentError.new("#{nucleotide} is not a nucleotide.")
    end
    strand.scan(nucleotide).count
  end

  def nucleotide_counts
    counts = {}
    %w(A T C G).each do |letter|
      counts[letter] = count(letter)
    end
    counts
  end

  def valid_nucleotide?(nucleotide)
    %w(A T C G U).include?(nucleotide)
  end

end
