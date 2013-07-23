require 'minitest/autorun'
require_relative 'series'

class SeriesTest < MiniTest::Unit::TestCase
  def test_digits
    assert_equal (0..9).to_a, Series.new("0123456789").digits
  end

  def test_same_digits_reversed
    skip
    assert_equal (0..9).to_a.reverse, Series.new("9876543210").digits
  end

  def test_fewer_digits
    skip
    assert_equal (4..8).to_a.reverse, Series.new("87654").digits
  end

  def test_some_other_digits
    skip
    assert_equal [9, 3, 6, 9, 2, 3, 4, 6, 8], Series.new("936923468").digits
  end

  def test_slices_of_zero
    skip
    assert_equal [], Series.new("").digits
  end

  def test_slices_of_2
    skip
    series = Series.new("01234")
    expected = [[0, 1], [1, 2], [2, 3], [3, 4]]
    assert_equal expected, series.slices(2)
  end

  def test_other_slices_of_2
    skip
    series = Series.new("98273463")
    expected = [[9, 8], [8, 2], [2, 7], [7, 3], [3, 4], [4, 6], [6, 3]]
    assert_equal expected, series.slices(2)
  end

  def test_slices_of_3
    skip
    series = Series.new("01234")
    expected = [[0, 1, 2], [1, 2, 3], [2, 3, 4]]
    assert_equal expected, series.slices(3)
  end

  def test_other_slices_of_3
    skip
    series = Series.new("982347")
    expected = [[9, 8, 2], [8, 2, 3], [2, 3, 4], [3, 4, 7]]
    assert_equal expected, series.slices(3)
  end

  def test_largest_product_of_2
    skip
    series = Series.new("0123456789")
    assert_equal 72, series.largest_product(2)
  end

  def test_largest_product_of_a_tiny_number
    skip
    series = Series.new("12")
    assert_equal 2, series.largest_product(2)
  end

  def test_another_tiny_number
    skip
    series = Series.new("19")
    assert_equal 9, series.largest_product(2)
  end

  def test_largest_product_of_2_shuffled
    skip
    series = Series.new("576802143")
    assert_equal 48, series.largest_product(2)
  end

  def test_largest_product_of_3
    skip
    series = Series.new("0123456789")
    assert_equal 504, series.largest_product(3)
  end

  def test_largest_product_of_3_shuffled
    skip
    series = Series.new("1027839564")
    assert_equal 270, series.largest_product(3)
  end

  def test_largest_product_of_5
    skip
    series = Series.new("0123456789")
    assert_equal 15120, series.largest_product(5)
  end

  def test_some_big_number
    skip
    s = '73167176531330624919225119674426574742355349194934'
    series = Series.new(s)
    assert_equal 23520, series.largest_product(6)
  end

  def test_some_other_big_number
    skip
    s = '52677741234314237566414902593461595376319419139427'
    series = Series.new(s)
    assert_equal 28350, series.largest_product(6)
  end

  def test_identity
    skip
    series = Series.new('')
    assert_equal 1, series.largest_product(0)
  end

  def test_slices_bigger_than_number
    skip
    series = Series.new("123")
    assert_raises ArgumentError do
      series.largest_product(4)
    end
  end
end
