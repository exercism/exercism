require 'minitest/autorun'
require_relative 'dna'

class DNATest < MiniTest::Unit::TestCase
  def test_empty_dna_string_has_no_adenosine
    assert_equal 0, DNA.new('').count('A')
  end

  def test_empty_dna_string_has_no_nucleotides
    skip
    expected = {'A' => 0, 'T' => 0, 'C' => 0, 'G' => 0}
    assert_equal expected, DNA.new("").nucleotide_counts
  end

  def test_repetitive_cytidine_gets_counted
    skip
    assert_equal 5, DNA.new('CCCCC').count('C')
  end

  def test_repetitive_sequence_has_only_guanosine
    skip
    expected = {'A' => 0, 'T' => 0, 'C' => 0, 'G' => 8}
    assert_equal expected, DNA.new('GGGGGGGG').nucleotide_counts
  end

  def test_counts_only_thymidine
    skip
    assert_equal 1, DNA.new('GGGGGTAACCCGG').count('T')
  end

  def test_counts_a_nucleotide_only_once
    skip
    dna = DNA.new('CGATTGGG')
    dna.count('T')
    assert_equal 2, dna.count('T')
  end

  def test_dna_has_no_uracil
    skip
    assert_equal 0, DNA.new('GATTACA').count('U')
  end

  def test_dna_counts_do_not_change_after_counting_uracil
    skip
    dna = DNA.new('GATTACA')
    dna.count('U')
    expected = {"A"=>3, "T"=>2, "C"=>1, "G"=>1}
    assert_equal expected, dna.nucleotide_counts
  end

  def test_validates_nucleotides
    skip
    assert_raises ArgumentError do
      DNA.new("GACT").count('X')
    end
  end

  def test_counts_all_nucleotides
    skip
    s = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC"
    dna = DNA.new(s)
    expected = {'A' => 20, 'T' => 21, 'G' => 17, 'C' => 12}
    assert_equal expected, dna.nucleotide_counts
  end
end
