require 'minitest/autorun'
require_relative 'beer_song'

class BeerSongTest < MiniTest::Unit::TestCase

  def beer_song
    @beer_song = ::BeerSong.new
  end

  def teardown
    @beer_song = nil
  end

  def test_a_typical_verse
    expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n"
    assert_equal expected, beer_song.verse(8)
  end

  def test_another_typical_verse
    skip
    expected = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n"
    assert_equal expected, beer_song.verse(3)
  end

  def test_verse_1
    skip
    expected = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
    assert_equal expected, beer_song.verse(1)
  end

  def test_verse_2
    skip
    expected = "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n"
    assert_equal expected, beer_song.verse(2)
  end

  def test_verse_0
    skip
    expected = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
    assert_equal expected, beer_song.verse(0)
  end

  def test_several_verses
    skip
    expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n\n"
    assert_equal expected, beer_song.verses(8, 6)
  end

  def test_all_the_rest_of_the_verses
    skip
    expected = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n\n2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n\n1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n\nNo more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n\n"
    assert_equal expected, beer_song.verses(3)
  end
end
