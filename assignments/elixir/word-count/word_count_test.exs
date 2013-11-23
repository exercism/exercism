Code.load_file("word-count.exs")
ExUnit.start

defmodule WordsTest do
  use ExUnit.Case

  test "count one word" do
    assert Words.count("word") == HashDict.new [{ "word", 1 }]
  end

  test "count one of each" do
    expected = HashDict.new [{ "one", 1 }, { "of", 1 }, { "each", 1 }]
    assert Words.count("one of each") == expected
  end

  test "count multiple occurrences" do
    expected = HashDict.new [{ "one", 1 }, { "fish", 4 }, { "two", 1 }, { "red", 1 }, { "blue", 1 }]
    assert Words.count("one fish two fish red fish blue fish") == expected
  end

  test "ignore punctuation" do
    expected = HashDict.new [{"car", 1}, {"carpet", 1}, {"as", 1}, {"java", 1}, {"javascript", 1}]
    assert Words.count("car : carpet as java : javascript!!&@$%^&") == expected
  end

  test "include numbers" do
    expected = HashDict.new [{"testing", 2}, {"1", 1}, {"2", 1}]
    assert Words.count("testing, 1, 2 testing") == expected
  end

  test "normalize case" do
    expected = HashDict.new [{"go", 3}]
    assert Words.count("go Go GO") == expected
  end
end
