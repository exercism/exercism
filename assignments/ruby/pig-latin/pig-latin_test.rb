require 'minitest/autorun'
require 'minitest/pride'
require_relative 'pig_latin'

class PigLatinTest < MiniTest::Unit::TestCase

  def test_word_beginning_with_a
    assert_equal "appleay", PigLatin.translate("apple")
  end

  def test_other_word_beginning_e
    skip
    assert_equal "earay", PigLatin.translate("ear")
  end

  def test_word_beginning_with_p
    skip
    assert_equal "igpay", PigLatin.translate("pig")
  end

  def test_word_beginning_with_k
    skip
    assert_equal "oalakay", PigLatin.translate("koala")
  end

  def test_word_beginning_with_ch
    skip
    assert_equal "airchay", PigLatin.translate("chair")
  end

  def test_word_beginning_with_qu
    skip
    assert_equal "eenquay", PigLatin.translate("queen")
  end

  def test_word_with_consonant_preceding_qu
    skip
    assert_equal "aresquay", PigLatin.translate("square")
  end

  def test_word_beginning_with_th
    skip
    assert_equal "erapythay", PigLatin.translate("therapy")
  end

  def test_word_beginning_with_thr
    skip
    assert_equal "ushthray", PigLatin.translate("thrush")
  end

  def test_word_beginning_with_sch
    skip
    assert_equal "oolschay", PigLatin.translate("school")
  end

  def test_translates_phrase
    skip
    assert_equal "ickquay astfay unray", PigLatin.translate("quick fast run")
  end

end
