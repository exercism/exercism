Code.load_file("accumulate.exs")
ExUnit.start

defmodule AccumulateTest do

  use ExUnit.Case, async: true

  test "empty accumulation" do
    assert [] == Accumulate.accumulate([], &(&1 * &1))
  end

  test "accumulate squares" do
    assert [1, 4, 9] == Accumulate.accumulate([1, 2, 3], &(&1 * &1))
  end

  test "accumulate upcases" do
    assert %w(HELLO WORLD) == Accumulate.accumulate(%w(hello world), &(String.upcase(&1)))
  end

  test "accumulate reversed strings" do
    assert %w(eht kciuq nworb xof cte) == Accumulate.accumulate(%w(the quick brown fox etc), &(String.reverse(&1)))
  end

  test "accumulate recursively" do
    result = Accumulate.accumulate(%w(a b c), fn(char) ->
      Accumulate.accumulate(%w(1 2 3), fn(digit) ->
        "#{char}#{digit}" 
      end) 
    end)
    assert [%w(a1 a2 a3), %w(b1 b2 b3), %w(c1 c2 c3)] == result
  end

  test "accumulate scaled range" do
    assert [2, 4, 6, 8, 10] == Accumulate.accumulate(1..5, &(&1 * 2))
  end

end