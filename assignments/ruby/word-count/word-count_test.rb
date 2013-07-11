require 'minitest/autorun'
require 'minitest/pride'
require_relative 'phrase'

class PhraseTest < MiniTest::Unit::TestCase

  def test_count_one_word
    phrase = Phrase.new("word")
    counts = {"word" => 1}
    assert_equal counts, phrase.word_count
  end

  def test_count_one_of_each
    skip
    phrase = Phrase.new("one of each")
    counts = {"one" => 1, "of" => 1, "each" => 1}
    assert_equal counts, phrase.word_count
  end

  def test_count_multiple_occurrences
    skip
    phrase = Phrase.new("one fish two fish red fish blue fish")
    counts = {"one"=>1, "fish"=>4, "two"=>1, "red"=>1, "blue"=>1}
    assert_equal counts, phrase.word_count
  end

  def test_ignore_punctuation
    skip
    phrase = Phrase.new("car : carpet as java : javascript!!&@$%^&")
    counts = {"car"=>1, "carpet"=>1, "as"=>1, "java"=>1, "javascript"=>1}
    assert_equal counts, phrase.word_count
  end

  def test_include_numbers
    skip
    phrase = Phrase.new("testing, 1, 2 testing")
    counts = {"testing" => 2, "1" => 1, "2" => 1}
    assert_equal counts, phrase.word_count
  end

  def test_normalize_case
    skip
    phrase = Phrase.new("go Go GO")
    counts = {"go" => 3}
    assert_equal counts, phrase.word_count
  end
end

