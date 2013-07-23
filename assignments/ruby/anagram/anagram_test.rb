require 'minitest/autorun'
require_relative 'anagram'

class AnagramTest < MiniTest::Unit::TestCase

  def test_no_matches
    detector = Anagram.new('diaper')
    assert_equal [], detector.match(%w(hello world zombies pants))
  end

  def test_detect_simple_anagram
    skip
    detector = Anagram.new('ba')
    anagrams = detector.match(['ab', 'abc', 'bac'])
    assert_equal ['ab'], anagrams
  end

  def test_detect_multiple_anagrams
    skip
    detector = Anagram.new('abc')
    anagrams = detector.match(['ab', 'abc', 'bac'])
    assert_equal ['abc', 'bac'], anagrams
  end

  def test_does_not_confuse_different_duplicates
    skip
    detector = Anagram.new('abb')
    assert_equal [], detector.match(['baa'])
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
    assert_equal ['gallery', 'regally', 'largely'], anagrams
  end
end
