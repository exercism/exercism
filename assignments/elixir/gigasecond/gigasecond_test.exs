if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("gigasecond.exs")
end

ExUnit.start

defmodule GigasecondTest do
  use ExUnit.Case

  test "from 4/25/2011" do
    assert {2043, 1, 1} == Gigasecond.from({2011, 4, 25})
  end

  test "from 6/13/1977" do
    # assert {2009, 2, 19} == Gigasecond.from({1977, 6, 13})
  end

  test "from 7/19/1959" do
    # assert {1991, 3, 27} == Gigasecond.from({1959, 7, 19})
  end

  test "yourself" do
    # customize these values for yourself
    #your_birthday = {year1, month1, day1}
    #assert {year2, month2, day2} == Gigasecond.from(your_birthday)
  end
end

