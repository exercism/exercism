require 'minitest/autorun'
require_relative 'hexadecimal'

class HexadecimalTest < MiniTest::Unit::TestCase
  def test_hex_1_is_decimal_1
    assert_equal 1, Hexadecimal.new("1").to_decimal
  end

  def test_hex_c_is_decimal_12
    skip
    assert_equal 12, Hexadecimal.new("c").to_decimal
  end

  def test_hex_10_is_decimal_16
    skip
    assert_equal 16, Hexadecimal.new("10").to_decimal
  end

  def test_hex_af_is_decimal_175
    skip
    assert_equal 175, Hexadecimal.new("af").to_decimal
  end

  def test_hex_100_is_decimal_256
    skip
    assert_equal 256, Hexadecimal.new("100").to_decimal
  end

  def test_hex_19ace_is_decimal_105166
    skip
    assert_equal 105166, Hexadecimal.new("19ace").to_decimal
  end

  def test_invalid_hex_is_decimal_0
    skip
    assert_equal 0, Hexadecimal.new("carrot").to_decimal
  end

  def test_black
    skip
    assert_equal 0, Hexadecimal.new("000000").to_decimal
  end

  def test_white
    skip
    assert_equal 16777215, Hexadecimal.new("ffffff").to_decimal
  end

  def test_yellow
    skip
    assert_equal 16776960, Hexadecimal.new("ffff00").to_decimal
  end
end
