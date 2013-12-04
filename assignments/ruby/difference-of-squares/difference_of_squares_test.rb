require 'minitest/autorun'
require_relative 'squares'

class SquaresTest < MiniTest::Unit::TestCase

  def test_square_of_sums_to_5
    assert_equal 225, Squares.new(5).square_of_sums
  end

  def test_sum_of_squares_to_5
    skip
    assert_equal 55, Squares.new(5).sum_of_squares
  end

  def test_difference_of_sums_to_5
    skip
    assert_equal 170, Squares.new(5).difference
  end

  def test_square_of_sums_to_10
    skip
    assert_equal 3025, Squares.new(10).square_of_sums
  end

  def test_sum_of_squares_to_10
    skip
    assert_equal 385, Squares.new(10).sum_of_squares
  end

  def test_difference_of_sums_to_10
    skip
    assert_equal 2640, Squares.new(10).difference
  end

  def test_square_of_sums_to_100
    skip
    assert_equal 25502500, Squares.new(100).square_of_sums
  end

  def test_sum_of_squares_to_100
    skip
    assert_equal 338350, Squares.new(100).sum_of_squares
  end

  def test_difference_of_sums_to_100
    skip
    assert_equal 25164150, Squares.new(100).difference
  end

end
