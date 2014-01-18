if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("phone_number.exs")
end

ExUnit.start

defmodule PhoneTest do
  use ExUnit.Case, async: true
  doctest Phone

  test "cleans number" do
    assert "1234567890" == Phone.number("(123) 456-7890")
  end

  test "cleans number with dots" do
    # assert "1234567890" == Phone.number("123.456.7890")
  end

  test "valid when 11 digits and first is 1" do
    # assert "1234567890" == Phone.number("11234567890")
  end

  test "invalid when 11 digits" do
    # assert "0000000000" == Phone.number("21234567890")
  end

  test "invalid when 9 digits" do
    # assert "0000000000" == Phone.number("123456789")
  end

  test "area code" do
    # assert "123" == Phone.area_code("1234567890")
  end

  test "pretty print" do
    # assert "(123) 456-7890" == Phone.pretty("1234567890")
  end

  test "pretty print with full us phone number" do
    # assert "(123) 456-7890" == Phone.pretty("11234567890")
  end
end
