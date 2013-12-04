require 'minitest/autorun'
require_relative 'scrabble'

class ScrabbleTest < MiniTest::Unit::TestCase
  def test_empty_word_scores_zero
    assert_equal 0, Scrabble.new("").score
  end

  def test_whitespace_scores_zero
    skip
    assert_equal 0, Scrabble.new(" \t\n").score
  end

  def test_nil_scores_zero
    skip
    assert_equal 0, Scrabble.new(nil).score
  end

  def test_scores_very_short_word
    skip
    assert_equal 1, Scrabble.new('a').score
  end

  def test_scores_other_very_short_word
    skip
    assert_equal 4, Scrabble.new('f').score
  end

  def test_simple_word_scores_the_number_of_letters
    skip
    assert_equal 6, Scrabble.new("street").score
  end

  def test_complicated_word_scores_more
    skip
    assert_equal 22, Scrabble.new("quirky").score
  end

  def test_scores_are_case_insensitive
    skip
    assert_equal 20, Scrabble.new("MULTIBILLIONAIRE").score
  end

  def test_convenient_scoring
    skip
    assert_equal 13, Scrabble.score("alacrity")
  end
end
