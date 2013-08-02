require 'minitest/autorun'
require_relative 'dna'

class RibonucleicAcidTest < MiniTest::Unit::TestCase
  def setup
    @cga = RibonucleicAcid.new('CGA')
    @agc = RibonucleicAcid.new('AGC')
  end

  def test_acid_equals_acid
    assert_equal @agc, @agc
    refute_equal @agc, @cga
  end

  def test_acid_equals_string
    skip
    assert_equal @agc, 'AGC'
    refute_equal @agc, 'CGA'
  end

  def test_string_equals_acid
    skip
    assert_equal 'AGC', @agc
    refute_equal 'CGA', @agc
  end
end

class DeoxyribonucleicAcidTest < RibonucleicAcidTest
  def setup
    skip
    @cga = DeoxyribonucleicAcid.new('CGA')
    @agc = DeoxyribonucleicAcid.new('AGC')
  end

  def test_similarity_of_acid_classes
    # skipped in setup()
    assert_equal DeoxyribonucleicAcid <= String,
                 RibonucleicAcid <= String,
                 "Acid classes not similar: one is a String, the other isn't"
  end

  def test_rna_conversion_returns_ribonucleic_acid_instance
    skip
    assert_instance_of RibonucleicAcid, DeoxyribonucleicAcid.new('C').to_rna
  end

  def test_transcribes_cytidine_unchanged
    skip
    assert_equal 'C', DeoxyribonucleicAcid.new('C').to_rna
  end

  def test_transcribes_guanosine_unchanged
    skip
    assert_equal 'G', DeoxyribonucleicAcid.new('G').to_rna
  end

  def test_transcribes_adenosine_unchanged
    skip
    assert_equal 'A', DeoxyribonucleicAcid.new('A').to_rna
  end

  def test_it_transcribes_thymidine_to_uracil
    skip
    assert_equal 'U', DeoxyribonucleicAcid.new('T').to_rna
  end

  def test_it_transcribes_all_occurrences_of_thymidine_to_uracil
    skip
    assert_equal 'ACGUGGUCUUAA', DeoxyribonucleicAcid.new('ACGTGGTCTTAA').to_rna
  end
end
