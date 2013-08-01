require 'minitest/autorun'
require_relative 'dna'

# Mixin with string-related tests for DNA and RNA objects.
# Working string operations will be needed for transcription tests.
module NucleicAcidStringTest
  def new_acid(sequence)
    fail 'abstract method not implemented'
    # Acid.new(sequence)
  end

  def test_string_equal_to_acid
    assert_equal 'C', new_acid('C')
  end

  def test_string_not_equal_to_acid
    skip
    refute_equal 'C', new_acid('G')
  end

  def test_acid_equal_to_string
    skip
    assert_equal new_acid('C'), 'C'
  end

  def test_acid_not_equal_to_string
    skip
    refute_equal new_acid('C'), 'G'
  end

  def test_acid_equal_to_acid
    skip
    assert_equal new_acid('C'), new_acid('C')
  end

  def test_acid_not_equal_to_acid
    skip
    refute_equal new_acid('C'), new_acid('G')
  end

  def test_new_acid_from_acid
    skip
    assert_equal new_acid('C'), new_acid(new_acid('C'))
  end

  def test_treating_acid_as_string_if_available
    if acid_wants_to_be_treated_as_a_string?
      skip
      assert_equal 'C', new_acid(new_acid('C')).to_str
      assert_equal String, new_acid(new_acid('C')).to_str.class
    end
  end

  def test_acid_string_representation_if_available
    if acid_has_a_string_representation?
      skip
      assert_equal 'C', new_acid(new_acid('C')).to_s
      assert_equal String, new_acid(new_acid('C')).to_s.class
    end
  end

  private

    def acid_wants_to_be_treated_as_a_string?
      new_acid('C').respond_to?(:to_str)
    end

    def acid_has_a_string_representation?
      new_acid('C').respond_to?(:to_s) ||
      new_acid('C').respond_to?(:to_str)
    end
end

# Test basic string functionality for RNA
class RNATest < MiniTest::Unit::TestCase
  include NucleicAcidStringTest
  def new_acid(sequence)
    RNA.new(sequence)
  end
end

# Test string and transcription funtions for DNA
class DNATest < MiniTest::Unit::TestCase
  include NucleicAcidStringTest
  def new_acid(sequence)
    DNA.new(sequence)
  end

  def test_transcribes_to_rna
    skip
    assert_kind_of RNA, DNA.new('C').to_rna
  end

  def test_acid_types_are_similar
    skip
    assert_equal DNA < String, RNA < String
    assert_equal DNA == String, RNA == String
  end

  def test_transcribes_cytidine_unchanged
    skip
    assert_equal 'C', DNA.new('C').to_rna
  end

  def test_transcribes_guanosine_unchanged
    skip
    assert_equal 'G', DNA.new('G').to_rna
  end

  def test_transcribes_adenosine_unchanged
    skip
    assert_equal 'A', DNA.new('A').to_rna
  end

  def test_it_transcribes_thymidine_to_uracil
    skip
    assert_equal 'U', DNA.new('T').to_rna
  end

  def test_it_transcribes_all_occurrences_of_thymidine_to_uracil
    skip
    assert_equal 'ACGUGGUCUUAA', DNA.new('ACGTGGTCTTAA').to_rna
  end
end

if DNA < String
  # Set `initialized_properly` when constructed.
  module CheckCallToInitialize
    attr_reader :initialized_properly

    def initialize(*)
      @initialized_properly = true
      super
    end
  end

  # Illustrate some potential surprises of String inheritance.
  # See http://words.steveklabnik.com/beware-subclassing-ruby-core-classes
  class StringInheritanceTest < MiniTest::Unit::TestCase
    # Reopen DNA to check if initialize() acts as expected
    class ::DNA
      include CheckCallToInitialize
    end

    def test_dna_tr_calls_initialize(*)
      skip
      dna = DNA.new('CGAU').tr(DNA.new('AU'), DNA.new('UA'))
      assert_kind_of DNA, dna
      assert dna.initialized_properly, 'DNA.tr result is not initialized'
    end

    def test_dna_chomp_calls_initialize(*)
      skip
      dna = DNA.new('CGAU').chomp
      assert_kind_of DNA, dna
      assert dna.initialized_properly, 'DNA.chomp result is not initialized'
    end

    def test_dna_concat_calls_initialize(*)
      skip
      dna = DNA.new('CGAU').delete(DNA.new('C'))
      assert_kind_of DNA, dna
      assert dna.initialized_properly, 'DNA.delete result is not initialized'
    end

    # ... and so on ...
  end
end
