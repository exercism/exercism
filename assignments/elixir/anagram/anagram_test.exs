Code.load_file("anagram.exs")
ExUnit.start

defmodule AnagramTest do
  use ExUnit.Case

  test "no matches" do
    matches = Anagram.match "diaper", ["hello", "world", "zombies", "pants"]
    assert matches == []
  end

  test "detect simple anagram" do
    # matches = Anagram.match "ba", ["ab", "abc", "bac"]
    # assert matches == ["ab"]
  end

  test "detect multiple anagrams" do
    # matches = Anagram.match "abc", ["ab", "abc", "bac"]
    # assert matches == ["abc", "bac"]
  end

  test "detect anagram" do
    # matches = Anagram.match "listen", %w(enlists google inlets banana)
    # assert matches == ["inlets"]
  end

  test "multiple anagrams" do
    # matches = Anagram.match "allergy", %w(gallery ballerina regally clergy largely leading)
    # assert matches == ["gallery", "regally", "largely"]
  end
end
