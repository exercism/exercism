require 'minitest/autorun'
require 'minitest/pride'
require_relative 'prime'

class TestPrimes < MiniTest::Unit::TestCase

  def test_first
    assert_equal 2, Prime.nth(1)
  end

  def test_second
    skip
    assert_equal 3, Prime.nth(2)
  end

  def test_sixth_prime
    skip
    assert_equal 13, Prime.nth(6)
  end

  def test_big_prime
    skip
    assert_equal 104743, Prime.nth(10001)
  end

  def test_weird_case
    skip
    assert_raises ArgumentError do
      Prime.nth(0)
    end
  end
end
