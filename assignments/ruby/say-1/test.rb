require 'minitest/autorun'
require 'minitest/pride'
require_relative 'say'

class SayTest < MiniTest::Unit::TestCase
  def test_zero
    assert_equal 'zero', Say.new(0).in_english
  end

  def test_one
    skip
    assert_equal 'one', Say.new(1).in_english
  end

  def test_fourteen
    skip
    # If your algorithm says 'ten-four'
    # you're doing it wrong
    assert_equal 'fourteen', Say.new(14).in_english
  end

  def test_twenty
    skip
    # This really shouldn't be twenty-zero
    assert_equal 'twenty', Say.new(20).in_english
  end

  def test_twenty_two
    skip
    assert_equal 'twenty-two', Say.new(22).in_english
  end

  def test_lower_bound
    skip
    assert_raises ArgumentError do
      Say.new(-1).in_english
    end
  end

  def test_upper_bound
    skip
    assert_raises ArgumentError do
      Say.new(100).in_english
    end
  end
end

