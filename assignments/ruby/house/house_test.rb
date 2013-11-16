require 'minitest/autorun'
require_relative 'house'

class HouseTest < MiniTest::Unit::TestCase
  def rhyme
    @rhyme = ::House.new
  end

  def teardown
    @rhyme = nil
  end

  def test_house
    expected = "This is the house that Jack built.\n"
    assert_equal expected, rhyme.verse(1)
  end

  def test_malt
    skip
    expected = "This is the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(2)
  end

  def test_rat
    skip
    expected = "This is the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(3)
  end

  def test_cat
    skip
    expected = "This is the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(4)
  end

  def test_dog
    skip
    expected = "This is the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(5)
  end

  def test_cow
    skip
    expected = "This is the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(6)
  end

  def test_maiden
    skip
    expected = "This is the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(7)
  end

  def test_man
    skip
    expected = "This is the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(8)
  end

  def test_priest
    skip
    expected = "This is the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(9)
  end

  def test_rooster
    skip
    expected = "This is the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(10)
  end

  def test_farmer
    skip
    expected = "This is the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(11)
  end

  def test_horse_and_hound_and_horn
    skip
    expected = "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"
    assert_equal expected, rhyme.verse(12)
  end

  def test_multiple_verses
    skip
    expected = ""
    expected << "This is the house that Jack built.\n\n"
    expected << "This is the malt that lay in the house that Jack built.\n\n"
    expected << "This is the rat that ate the malt that lay in the house that Jack built.\n\n"

    assert_equal expected, rhyme.verses(1, 3)
  end
end

