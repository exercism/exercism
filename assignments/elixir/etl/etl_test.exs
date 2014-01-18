if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("etl.exs")
end

ExUnit.start

defmodule TransformTest do
  use ExUnit.Case, async: true
  doctest ETL

  test "transform one value" do
    old = HashDict.new [{1, ["WORLD"]}]
    expected = HashDict.new [{"world", 1}]

    assert expected == ETL.transform(old)
  end

  test "transform more values" do
    old = HashDict.new [{1, ["WORLD", "GSCHOOLERS"]}]
    expected = HashDict.new [{"world", 1}, {"gschoolers", 1}]

    assert expected == ETL.transform(old)
  end

  test "more keys" do
    old = HashDict.new [{1, ["APPLE", "ARTICHOKE"]}, {2, ["BOAT", "BALLERINA"]}]
    expected = HashDict.new [
      {"apple", 1},
      {"artichoke", 1},
      {"boat", 2},
      {"ballerina", 2}
    ]

    assert expected == ETL.transform(old)
  end

  test "full dataset" do
    old = HashDict.new [
      {1,  %W(A E I O U L N R S T)},
      {2,  %W(D G)},
      {3,  %W(B C M P)},
      {4,  %W(F H V W Y)},
      {5,  %W(K)},
      {8,  %W(J X)},
      {10, %W(Q Z)}
    ]

    expected = HashDict.new [
      {"a", 1}, {"b", 3},  {"c", 3}, {"d", 2}, {"e", 1},
      {"f", 4}, {"g", 2},  {"h", 4}, {"i", 1}, {"j", 8},
      {"k", 5}, {"l", 1},  {"m", 3}, {"n", 1}, {"o", 1},
      {"p", 3}, {"q", 10}, {"r", 1}, {"s", 1}, {"t", 1},
      {"u", 1}, {"v", 4},  {"w", 4}, {"x", 8}, {"y", 4},
      {"z", 10}
    ]

    assert expected == ETL.transform(old)
  end
end
