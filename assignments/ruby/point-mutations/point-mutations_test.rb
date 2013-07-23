require 'minitest/autorun'
require_relative 'dna'

class DNATest < MiniTest::Unit::TestCase

  def test_no_difference_between_empty_strands
    assert_equal 0, DNA.new('').hamming_distance('')
  end

  def test_no_difference_between_identical_strands
    skip
    assert_equal 0, DNA.new('GGACTGA').hamming_distance('GGACTGA')
  end

  def test_complete_hamming_distance_in_small_strand
    skip
    assert_equal 3, DNA.new('ACT').hamming_distance('GGA')
  end

  def test_hamming_distance_in_off_by_one_strand
    skip
    assert_equal 19, DNA.new('GGACGGATTCTGACCTGGACTAATTTTGGGG').hamming_distance('AGGACGGATTCTGACCTGGACTAATTTTGGGG')
  end

  def test_small_hamming_distance_in_middle_somewhere
    skip
    assert_equal 1, DNA.new('GGACG').hamming_distance('GGTCG')
  end

  def test_larger_distance
    skip
    assert_equal 2, DNA.new('ACCAGGG').hamming_distance('ACTATGG')
  end

  def test_ignores_extra_length_on_other_strand_when_longer
    skip
    assert_equal 3, DNA.new('AAACTAGGGG').hamming_distance('AGGCTAGCGGTAGGAC')
  end

  def test_ignores_extra_length_on_original_strand_when_longer
    skip
    assert_equal 5, DNA.new('GACTACGGACAGGGTAGGGAAT').hamming_distance('GACATCGCACACC')
  end

  def test_does_not_actually_shorten_original_strand
    skip
    assert_equal 1, DNA.new('AGACAACAGCCAGCCGCCGGATT').hamming_distance('AGGCAA')
    assert_equal 4, DNA.new('AGACAACAGCCAGCCGCCGGATT').hamming_distance('AGACATCTTTCAGCCGCCGGATTAGGCAA')
    assert_equal 1, DNA.new('AGACAACAGCCAGCCGCCGGATT').hamming_distance('AGG')
  end

end
