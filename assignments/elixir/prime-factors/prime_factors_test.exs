if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("prime_factors.exs")
end

ExUnit.start

defmodule PrimeFactorsTest do
  use ExUnit.Case, async: true
  doctest PrimeFactors

  test "1" do
    assert [] == PrimeFactors.factors_for(1)
  end

  test "2" do
    assert [2] == PrimeFactors.factors_for(2)
  end

  test "3" do
    assert [3] == PrimeFactors.factors_for(3)
  end

  test "4" do
    assert [2, 2] == PrimeFactors.factors_for(4)
  end

  test "6" do
    assert [2, 3] == PrimeFactors.factors_for(6)
  end

  test "8" do
    assert [2, 2, 2] == PrimeFactors.factors_for(8)
  end

  test "9" do
    assert [3, 3] == PrimeFactors.factors_for(9)
  end

  test "27" do
    assert [3, 3, 3] == PrimeFactors.factors_for(27)
  end

  test "625" do
    assert [5, 5, 5, 5] == PrimeFactors.factors_for(625)
  end

  test "901255" do
    assert [5, 17, 23, 461] == PrimeFactors.factors_for(901255)
  end

  test "93819012551" do
    assert [11, 9539, 894119] == PrimeFactors.factors_for(93819012551)
  end
end
