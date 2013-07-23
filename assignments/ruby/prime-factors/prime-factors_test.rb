require 'minitest/autorun'
require_relative 'prime_factors'

class PrimeFactorsTest < MiniTest::Unit::TestCase

  def test_1
    assert_equal [], PrimeFactors.for(1)
  end

  def test_2
    skip
    assert_equal [2], PrimeFactors.for(2)
  end

  def test_3
    skip
    assert_equal [3], PrimeFactors.for(3)
  end

  def test_4
    skip
    assert_equal [2, 2], PrimeFactors.for(4)
  end

  def test_6
    skip
    assert_equal [2, 3], PrimeFactors.for(6)
  end

  def test_8
    skip
    assert_equal [2, 2, 2], PrimeFactors.for(8)
  end

  def test_9
    skip
    assert_equal [3, 3], PrimeFactors.for(9)
  end

  def test_27
    skip
    assert_equal [3, 3, 3], PrimeFactors.for(27)
  end

  def test_625
    skip
    assert_equal [5, 5, 5, 5], PrimeFactors.for(625)
  end

  def test_901255
    skip
    assert_equal [5, 17, 23, 461], PrimeFactors.for(901255)
  end

  def test_93819012551
    skip
    assert_equal [11, 9539, 894119], PrimeFactors.for(93819012551)
  end

end
