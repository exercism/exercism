if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("difference_of_squares.exs")
end

ExUnit.start

defmodule DifferenceOfSquaresTest do
  use ExUnit.Case, async: true

  test "square of sums to 5" do
    assert 225 == Squares.square_of_sums(5)
  end

  test "sum of squares to 5" do
    assert 55 == Squares.sum_of_squares(5)
  end

  test "difference of sums to 5" do
    assert 170 == Squares.difference(5)
  end

  test "square of sums to 10" do
    assert 3025 == Squares.square_of_sums(10)
  end

  test "sum of squares to 10" do
    assert 385 == Squares.sum_of_squares(10)
  end

  test "difference of sums to 10" do
    assert 2640 == Squares.difference(10)
  end

  test "square of sums to 100" do
    assert 25502500 == Squares.square_of_sums(100)
  end

  test "sum of squares to 100" do
    assert 338350 == Squares.sum_of_squares(100)
  end

  test "difference of sums to 100" do
    assert 25164150 == Squares.difference(100)
  end

end