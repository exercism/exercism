require 'minitest/autorun'
require_relative 'series'

class SeriesTest < MiniTest::Unit::TestCase

  def test_simple_slices_of_one
    series = Series.new("01234")
    assert_equal [[0], [1], [2], [3], [4]], series.slices(1)
  end

  def test_simple_slices_of_one_again
    skip
    series = Series.new("92834")
    assert_equal [[9], [2], [8], [3], [4]], series.slices(1)
  end

  def test_simple_slices_of_two
    skip
    series = Series.new("01234")
    assert_equal [[0, 1], [1, 2], [2, 3], [3, 4]], series.slices(2)
  end

  def test_other_slices_of_two
    skip
    series = Series.new("98273463")
    expected = [[9, 8], [8, 2], [2, 7], [7, 3], [3, 4], [4, 6], [6, 3]]
    assert_equal expected, series.slices(2)
  end

  def test_simple_slices_of_two_again
    skip
    series = Series.new("37103")
    assert_equal [[3, 7], [7, 1], [1, 0], [0, 3]], series.slices(2)
  end

  def test_simple_slices_of_three
    skip
    series = Series.new("01234")
    assert_equal [[0, 1, 2], [1, 2, 3], [2, 3, 4]], series.slices(3)
  end

  def test_simple_slices_of_three_again
    skip
    series = Series.new("31001")
    assert_equal [[3, 1, 0], [1, 0, 0], [0, 0, 1]], series.slices(3)
  end

  def test_other_slices_of_three
    skip
    series = Series.new("982347")
    expected = [[9, 8, 2], [8, 2, 3], [2, 3, 4], [3, 4, 7]]
    assert_equal expected, series.slices(3)
  end

  def test_simple_slices_of_four
    skip
    series = Series.new("01234")
    assert_equal [[0, 1, 2, 3], [1, 2, 3, 4]], series.slices(4)
  end

  def test_simple_slices_of_four_again
    skip
    series = Series.new("91274")
    assert_equal [[9, 1, 2, 7], [1, 2, 7, 4]], series.slices(4)
  end

  def test_simple_slices_of_five
    skip
    series = Series.new("01234")
    assert_equal [[0, 1, 2, 3, 4]], series.slices(5)
  end

  def test_simple_slices_of_five_again
    skip
    series = Series.new("81228")
    assert_equal [[8, 1, 2, 2, 8]], series.slices(5)
  end

  def test_simple_slice_that_blows_up
    skip
    series = Series.new("01234")
    assert_raises ArgumentError do
      series.slices(6)
    end
  end

  def test_more_complicated_slice_that_blows_up
    skip
    slice_string = "01032987583"
    
    series = Series.new(slice_string)
    assert_raises ArgumentError do
      series.slices(slice_string.length + 1)
    end
  end
end
