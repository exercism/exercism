if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("sum_of_multiples.exs")
end

ExUnit.start

defmodule SumOfMultiplesTest do
  use ExUnit.Case, async: true

  test "sum to 1" do
    assert 0 == SumOfMultiples.to(1)
  end

  test "sum to 3" do
    assert 3 == SumOfMultiples.to(4)
  end

  test "sum to 10" do
    assert 23 == SumOfMultiples.to(10)
  end

  test "sum to 1000" do
    assert 233168 == SumOfMultiples.to(1000)
  end

  test "configurable 7, 13, 17 to 20" do
    multiples = [7, 13, 17]
    assert 51 == SumOfMultiples.to(20, multiples)
  end

  test "configurable 43, 47 to 10000" do
    multiples = [43, 47]
    assert 2203160 == SumOfMultiples.to(10000, multiples)
  end

end