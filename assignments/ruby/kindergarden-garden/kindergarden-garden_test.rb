require 'minitest/autorun'
require_relative 'garden'

class GardenTest < MiniTest::Unit::TestCase

  def test_alices_garden
    garden = Garden.new("RC\nGG")
    assert_equal [:radishes, :clover, :grass, :grass], garden.alice
  end

  def test_different_garden_for_alice
    skip
    garden = Garden.new("VC\nRC")
    assert_equal [:violets, :clover, :radishes, :clover], garden.alice
  end

  def test_bobs_garden
    skip
    garden = Garden.new("VVCG\nVVRC")
    assert_equal [:clover, :grass, :radishes, :clover], garden.bob
  end

  def test_bob_and_charlies_gardens
    skip
    garden = Garden.new("VVCCGG\nVVCCGG")
    assert_equal [:clover, :clover, :clover, :clover], garden.bob
    assert_equal [:grass, :grass, :grass, :grass], garden.charlie
  end

end

class TestFullGarden < MiniTest::Unit::TestCase
  def setup
    diagram = "VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV"
    @garden = Garden.new(diagram)
  end

  def garden
    @garden
  end

  def test_alice
    skip
    assert_equal [:violets, :radishes, :violets, :radishes], garden.alice
  end

  def test_bob
    skip
    assert_equal [:clover, :grass, :clover, :clover], garden.bob
  end

  def test_charlie
    skip
    assert_equal [:violets, :violets, :clover, :grass], garden.charlie
  end

  def test_david
    skip
    assert_equal [:radishes, :violets, :clover, :radishes], garden.david
  end

  def test_eve
    skip
    assert_equal [:clover, :grass, :radishes, :grass], garden.eve
  end

  def test_fred
    skip
    assert_equal [:grass, :clover, :violets, :clover], garden.fred
  end

  def test_ginny
    skip
    assert_equal [:clover, :grass, :grass, :clover], garden.ginny
  end

  def test_harriet
    skip
    assert_equal [:violets, :radishes, :radishes, :violets], garden.harriet
  end

  def test_ileana
    skip
    assert_equal [:grass, :clover, :violets, :clover], garden.ileana
  end

  def test_joseph
    skip
    assert_equal [:violets, :clover, :violets, :grass], garden.joseph
  end

  def test_kincaid
    skip
    assert_equal [:grass, :clover, :clover, :grass], garden.kincaid
  end

  def test_larry
    skip
    assert_equal [:grass, :violets, :clover, :violets], garden.larry
  end
end

class DisorderedTest < MiniTest::Unit::TestCase

  def setup
    diagram = "VCRRGVRG\nRVGCCGCV"
    students = ["Samantha", "Patricia", "Xander", "Roger"]
    @garden = Garden.new(diagram, students)
  end

  def garden
    @garden
  end

  def test_patricia
    skip
    assert_equal [:violets, :clover, :radishes, :violets], garden.patricia
  end

  def test_roger
    skip
    assert_equal [:radishes, :radishes, :grass, :clover], garden.roger
  end

  def test_samantha
    skip
    assert_equal [:grass, :violets, :clover, :grass], garden.samantha
  end

  def test_xander
    skip
    assert_equal [:radishes, :grass, :clover, :violets], garden.xander
  end

end

class TwoGardensDifferentStudents < MiniTest::Unit::TestCase
 def diagram
   "VCRRGVRG\nRVGCCGCV"
 end

 def garden_1
   @garden_1 ||= Garden.new(diagram, ["Alice", "Bob", "Charlie", "Dan"])
 end

 def garden_2
   @garden_2 ||= Garden.new(diagram, ["Bob", "Charlie", "Dan", "Erin"])
 end

 def test_bob_and_charlie_per_garden
   skip
   assert_equal [:radishes, :radishes, :grass, :clover], garden_1.bob
   assert_equal [:violets, :clover, :radishes, :violets], garden_2.bob
   assert_equal [:grass, :violets, :clover, :grass], garden_1.charlie
   assert_equal [:radishes, :radishes, :grass, :clover], garden_2.charlie
 end
end
