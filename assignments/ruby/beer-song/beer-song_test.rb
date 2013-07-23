require 'minitest/autorun'
require_relative 'beer'

class BeerTest < MiniTest::Unit::TestCase

  attr_reader :beer
  def setup
    @beer = Beer.new
  end

  def test_a_verse
    expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n"
    assert_equal expected, beer.verse(8)
  end

  def test_verse_1
    skip
    expected = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
    assert_equal expected, beer.verse(1)
  end

  def test_verse_2
    skip
    expected = "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n"
    assert_equal expected, beer.verse(2)
  end

  def test_verse_0
    skip
    expected = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
    assert_equal expected, beer.verse(0)
  end

  def test_singing_several_verses
    skip
    expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n\n"
    assert_equal expected, beer.sing(8, 6)
  end

  def test_sing_all_the_rest_of_the_verses
    skip
    expected = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n\n2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n\n1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n\nNo more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n\n"
    assert_equal expected, beer.sing(3)
  end
end
