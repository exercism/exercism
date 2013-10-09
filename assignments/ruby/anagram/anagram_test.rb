require 'minitest/autorun'
require_relative 'anagram'

class AnagramTest < MiniTest::Unit::TestCase

  def test_no_matches
    detector = Anagram.new('diaper')
    assert_equal [], detector.match(%w(hello world zombies pants))
  end

  def test_detect_simple_anagram
    skip
    detector = Anagram.new('ant')
    anagrams = detector.match(['tan', 'stand', 'at'])
    assert_equal ['tan'], anagrams
  end

  def test_detect_multiple_anagrams
    skip
    detector = Anagram.new('master')
    anagrams = detector.match(['stream', 'pigeon', 'maters'])
    assert_equal ['maters', 'stream'], anagrams.sort
  end

  def test_does_not_confuse_different_duplicates
    skip
    detector = Anagram.new('galea')
    assert_equal [], detector.match(['eagle'])
  end

  def test_identical_word_is_not_anagram
    skip
    detector = Anagram.new('corn')
    anagrams = detector.match %w(corn dark Corn rank CORN cron park)
    assert_equal ['cron'], anagrams
  end

  def test_eliminate_anagrams_with_same_checksum
    skip
    detector = Anagram.new('mass')
    assert_equal [], detector.match(['last'])
  end

  def test_eliminate_anagram_subsets
    skip
    detector = Anagram.new('good')
    assert_equal [], detector.match(['dog', 'goody'])
  end

  def test_detect_anagram
    skip
    detector = Anagram.new('listen')
    anagrams = detector.match %w(enlists google inlets banana)
    assert_equal ['inlets'], anagrams
  end

  def test_multiple_anagrams
    skip
    detector = Anagram.new('allergy')
    anagrams = detector.match %w(gallery ballerina regally clergy largely leading)
    assert_equal ['gallery', 'largely', 'regally'], anagrams.sort
  end

  def test_anagrams_are_case_insensitive
    skip
    detector = Anagram.new('Orchestra')
    anagrams = detector.match %w(cashregister Carthorse radishes)
    assert_equal ['Carthorse'], anagrams
  end
end
