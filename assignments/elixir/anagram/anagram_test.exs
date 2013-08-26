Code.load_file("anagram.exs")
ExUnit.start

defmodule AnagramTest do
  use ExUnit.Case

  test "no matches" do
    matches = Anagram.match "diaper", ["hello", "world", "zombies", "pants"]
    assert matches == []
  end

  test "detect simple anagram" do
    # matches = Anagram.match "ant", ["tan", "stand", "at"]
    # assert matches == ["tan"]
  end

  test "detect multiple anagrams" do
    # matches = Anagram.match "master", ["stream", "pigeon", "maters"]
    # assert matches == ["stream", "maters"]
  end

  test "do not detect anagram subsets" do
    # matches = Anagram.match "good", %w(dog goody)
    # assert matches == []
  end

  test "detect anagram" do
    # matches = Anagram.match "listen", %w(enlists google inlets banana)
    # assert matches == ["inlets"]
  end

  test "multiple anagrams" do
    # matches = Anagram.match "allergy", %w(gallery ballerina regally clergy largely leading)
    # assert matches == ["gallery", "regally", "largely"]
  end

  test "detect anagrams case-insensitively" do
    # matches = Anagram.match "Orchestra", %w(cashregister Carthorse radishes)
    # assert matches == ["Carthorse"]
  end

  test "anagrams must not be the source word" do
    # matches = Anagram.match "banana", ["banana"]
    # assert matches == []
  end

  test "anagrams must not be the source word case-insensitively" do
    # matches = Anagram.match "banana", ["Banana"]
    # assert matches == []
  end

  test "anagrams must use all letters exactly once" do
    # matches = Anagram.match "patter", ["tapper"]
    # assert matches == []
  end
end
