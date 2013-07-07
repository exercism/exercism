Code.load_file("year.exs")
ExUnit.start

defmodule LeapTest do
  use ExUnit.Case, async: true
  doctest Year

  test "vanilla leap year" do
    assert Year.leap_year?(1996)
  end

  test "any old year" do
    # assert ! Year.leap_year?(1997)
  end

  test "century" do
    # assert ! Year.leap_year?(1900)
  end

  test "exceptional century" do
    # assert Year.leap_year?(2000)
  end
end
