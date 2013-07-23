require 'minitest/autorun'
require_relative 'luhn'

class LuhnTest < MiniTest::Unit::TestCase

  def test_addends
    luhn = Luhn.new(12121)
    assert_equal [1, 4, 1, 4, 1], luhn.addends
  end

  def test_too_large_addend
    skip
    luhn = Luhn.new(8631)
    assert_equal [7, 6, 6, 1], luhn.addends
  end

  def test_checksum
    skip
    luhn = Luhn.new(4913)
    assert_equal 22, luhn.checksum
  end

  def test_checksum_again
    skip
    luhn = Luhn.new(201773)
    assert_equal 21, luhn.checksum
  end

  def test_invalid_number
    skip
    luhn = Luhn.new(738)
    assert !luhn.valid?
  end

  def test_valid_number
    skip
    luhn = Luhn.new(8739567)
    assert luhn.valid?
  end

  def test_create_valid_number
    skip
    number = Luhn.create(123)
    assert_equal 1230, number
  end

  def test_create_other_valid_number
    skip
    number = Luhn.create(873956)
    assert_equal 8739567, number
  end

  def test_create_yet_another_valid_number
    skip
    number = Luhn.create(837263756)
    assert_equal 8372637564, number
  end

end
