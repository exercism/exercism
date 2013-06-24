require 'minitest/autorun'
require 'minitest/pride'
require_relative 'dna'

class DNATest < MiniTest::Unit::TestCase

  def test_transcribes_cytidine_unchanged
    assert_equal 'C', DNA.new("C").to_rna
  end

  def test_transcribes_guanosine_unchanged
    skip
    assert_equal 'G', DNA.new("G").to_rna
  end

  def test_transcribes_adenosine_unchanged
    skip
    assert_equal 'A', DNA.new("A").to_rna
  end

  def test_it_transcribes_thymidine_to_uracil
    skip
    assert_equal 'U', DNA.new("T").to_rna
  end

  def test_it_transcribes_all_occurrences_of_thymidine_to_uracil
    skip
    assert_equal 'ACGUGGUCUUAA', DNA.new('ACGTGGTCTTAA').to_rna
  end

end
