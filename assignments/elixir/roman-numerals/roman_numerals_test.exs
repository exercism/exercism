if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("roman.exs")
end

ExUnit.start

defmodule RomanTest do
  use ExUnit.Case, async: true
  doctest Roman

  test "1" do
    assert "I" == Roman.numerals(1)
  end

  test "2" do
    assert "II" == Roman.numerals(2)
  end

  test "3" do
    assert "III" == Roman.numerals(3)
  end

  test "4" do
    assert "IV" == Roman.numerals(4)
  end

  test "5" do
    assert "V" == Roman.numerals(5)
  end

  test "6" do
    assert "VI" == Roman.numerals(6)
  end

  test "9" do
    assert "IX" == Roman.numerals(9)
  end

  test "27" do
    assert "XXVII" == Roman.numerals(27)
  end

  test "48" do
    assert "XLVIII" == Roman.numerals(48)
  end

  test "59" do
    assert "LIX" == Roman.numerals(59)
  end

  test "93" do
    assert "XCIII" == Roman.numerals(93)
  end

  test "141" do
    assert "CXLI" == Roman.numerals(141)
  end

  test "163" do
    assert "CLXIII" == Roman.numerals(163)
  end

  test "402" do
    assert "CDII" == Roman.numerals(402)
  end

  test "575" do
    assert "DLXXV" == Roman.numerals(575)
  end

  test "911" do
    assert "CMXI" == Roman.numerals(911)
  end

  test "1024" do
    assert "MXXIV" == Roman.numerals(1024)
  end

  test "3000" do
    assert "MMM" == Roman.numerals(3000)
  end
end
