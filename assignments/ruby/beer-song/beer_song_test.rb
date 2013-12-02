require 'minitest/autorun'
require_relative 'beer_song'

class BeerSongTest < MiniTest::Unit::TestCase

  def song
    @song = ::BeerSong.new
  end

  def teardown
    @song = nil
  end

  def test_a_typical_verse
    expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n"
    assert_equal expected, song.verse(8)
  end

  def test_another_typical_verse
    expected = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n"
    assert_equal expected, song.verse(3)
  end

  def test_verse_1
    expected = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
    assert_equal expected, song.verse(1)
  end

  def test_verse_2
    expected = "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n"
    assert_equal expected, song.verse(2)
  end

  def test_verse_0
    expected = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
    assert_equal expected, song.verse(0)
  end

  def test_several_verses
    expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n\n"
    assert_equal expected, song.verses(8, 6)
  end

  def test_the_whole_song
    assert_equal song.verses(99, 0), song.sing
  end
end
