require 'minitest/autorun'
require 'minitest/pride'
require_relative 'sum'

class SumTest < MiniTest::Unit::TestCase

  def test_sum_to_1
    assert_equal 0, SumOfMultiples.to(1)
  end

  def test_sum_to_3
    skip
    assert_equal 3, SumOfMultiples.to(4)
  end

  def test_sum_to_10
    skip
    assert_equal 23, SumOfMultiples.to(10)
  end

  def test_sum_to_1000
    skip
    assert_equal 233168, SumOfMultiples.to(1000)
  end

  def test_configurable_7_13_17_to_20
    skip
    assert_equal 51, SumOfMultiples.new(7, 13, 17).to(20)
  end

  def test_configurable_43_47_to_10000
    skip
    assert_equal 2203160, SumOfMultiples.new(43, 47).to(10_000)
  end

end
