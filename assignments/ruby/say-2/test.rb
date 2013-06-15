require 'minitest/autorun'
require 'minitest/pride'
require_relative 'say'

class SayTest < MiniTest::Unit::TestCase
  def test_0
    assert_equal [0, 0, 0, 0], Say.new(0).chunks
  end

  def test_100
    skip
    assert_equal [0, 0, 0, 100], Say.new(100).chunks
  end

  def test_1_thousand
    skip
    assert_equal [0, 0, 1, 0], Say.new(1000).chunks
  end

  def test_1_thousand_234
    skip
    assert_equal [0, 0, 1, 234], Say.new(1234).chunks
  end

  def test_1_million
    skip
    assert_equal [0, 1, 0, 0], Say.new(10**6).chunks
  end

  def test_1_million_and_some_crumbs
    skip
    assert_equal [0, 1, 0, 2], Say.new(1000002).chunks
  end

  def test_1_million_2_thousand_345
    skip
    assert_equal [0, 1, 2, 345], Say.new(1002345).chunks
  end

  def test_1_billion
    skip
    assert_equal [1, 0, 0, 0], Say.new(10**9).chunks
  end

  def test_really_big_number
    skip
    assert_equal [987, 654, 321, 123], Say.new(987654321123).chunks
  end

  def test_lower_bound
    skip
    assert_raises ArgumentError do
      Say.new(-1).chunks
    end
  end

  def test_upper_bound
    skip
    assert_raises ArgumentError do
      Say.new(1000000000000).chunks
    end
  end
end

