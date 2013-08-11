Code.load_file("scrabble.exs")
ExUnit.start

defmodule ScrabbleScoreTest do
  use ExUnit.Case, async: true
  doctest Scrabble

  test "empty word scores zero" do
    assert 0 == Scrabble.score("")
  end

  test "whitespace scores zero" do
    assert 0 == Scrabble.score(" \t\n")
  end

  test "scores very short word" do
    assert 1 == Scrabble.score("a")
  end

  test "scores other very short word" do
    assert 4 == Scrabble.score("f")
  end

  test "simple word scores the number of letters" do
    assert 6 == Scrabble.score("street")
  end

  test "complicated word scores more" do
    assert 22 == Scrabble.score("quirky")
  end

  test "scores are case insensitive" do
    assert 20 == Scrabble.score("MULTIBILLIONAIRE")
  end

  test "convenient scoring" do
    assert 13 == Scrabble.score("alacrity")
  end
end
