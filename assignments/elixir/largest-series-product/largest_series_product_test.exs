Code.load_file("largest_series_product.exs")
ExUnit.start

defmodule LargestSeriesProductTest do
  use ExUnit.Case, async: false

  test "digits" do
    assert [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] == Series.digits("0123456789")
  end

  test "same digits reversed" do
    assert [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] == Series.digits("9876543210")
  end

  test "fewer digits" do
    assert [8, 7, 6, 5, 4] == Series.digits("87654")
  end

  test "some other digits" do
    assert [9, 3, 6, 9, 2, 3, 4, 6, 8] == Series.digits("936923468")
  end

  test "slices of zero" do
    assert [] == Series.digits("")
  end

  test "slices of two" do
    assert [[0, 1], [1, 2], [2, 3], [3, 4]] == Series.slices("01234", 2)
  end

  test "other slices of two" do
    assert [[9, 8], [8, 2], [2, 7], [7, 3], [3, 4], [4, 6], [6, 3]] == Series.slices("98273463", 2)
  end

  test "slices of three" do
    assert [[0, 1, 2], [1, 2, 3], [2, 3, 4]] == Series.slices("01234", 3)
  end

  test "other slices of three" do
    assert [[9, 8, 2], [8, 2, 3], [2, 3, 4], [3, 4, 7]] == Series.slices("982347", 3)
  end

  test "largest product of 2" do
    assert 72 == Series.largest_product("0123456789", 2)
  end

  test "largest product of a tiny number" do
    assert 2 == Series.largest_product("12", 2)
  end

  test "another tiny number" do
    assert 9 == Series.largest_product("19", 2)
  end

  test "largest product of 2 shuffled" do
    assert 48 == Series.largest_product("576802143", 2)
  end

  test "largest product of 3" do
    assert 504 == Series.largest_product("0123456789", 3)
  end

  test "largest product of 3 shuffled" do
    assert 270 == Series.largest_product("1027839564", 3)
  end

  test "largest product of 5" do
    assert 15120 == Series.largest_product("0123456789", 5)
  end

  test "some big number" do
    assert 23520 == Series.largest_product("73167176531330624919225119674426574742355349194934", 6)
  end

  test "some other big number" do
    assert 28350 == Series.largest_product("52677741234314237566414902593461595376319419139427", 6)
  end

  test "identity" do
    assert 1 == Series.largest_product("", 0)
  end
end