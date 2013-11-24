require 'minitest/autorun'
require_relative 'phone_number'

class PhoneNumberTest < MiniTest::Unit::TestCase

  def test_cleans_number
    number = PhoneNumber.new("(123) 456-7890").number
    assert_equal "1234567890", number
  end

  def test_cleans_a_different_number
    skip
    number = PhoneNumber.new("(987) 654-3210").number
    assert_equal "9876543210", number
  end

  def test_cleans_number_with_dots
    skip
    number = PhoneNumber.new("456.123.7890").number
    assert_equal "4561237890", number
  end

  def test_invalid_with_letters_in_place_of_numbers
    skip
    number = PhoneNumber.new("123-abc-1234").number
    assert_equal "0000000000", number
  end

  def test_invalid_when_9_digits
    skip
    number = PhoneNumber.new("123456789").number
    assert_equal "0000000000", number
  end

  def test_valid_when_11_digits_and_first_is_1
    skip
    number = PhoneNumber.new("19876543210").number
    assert_equal "9876543210", number
  end

  def test_invalid_when_11_digits
    skip
    number = PhoneNumber.new("21234567890").number
    assert_equal "0000000000", number
  end

  def test_invalid_when_12_digits_and_first_is_1
    skip
    number = PhoneNumber.new("112345678901").number
    assert_equal "0000000000", number
  end

  def test_area_code
    skip
    number = PhoneNumber.new("1234567890")
    assert_equal "123", number.area_code
  end

  def test_different_area_code
    skip
    number = PhoneNumber.new("9876543210")
    assert_equal "987", number.area_code
  end

  def test_pretty_print
    skip
    number = PhoneNumber.new("5551234567")
    assert_equal "(555) 123-4567", number.to_s
  end

  def test_pretty_print_with_full_us_phone_number
    skip
    number = PhoneNumber.new("11234567890")
    assert_equal "(123) 456-7890", number.to_s
  end
end
