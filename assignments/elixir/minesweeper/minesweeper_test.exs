Code.load_file("minesweeper.exs")
ExUnit.start

defmodule MinesweeperTest do
  use ExUnit.Case, async: true
  doctest Minesweeper 

  defp clean(b), do: Enum.map(b, &String.replace(&1, %r/[^*]/, " "))

  test "zero size board" do
    b = []
    assert b == Minesweeper.annotate(clean(b))
  end

  test "empty board" do
    b = ["   ",
         "   ",
         "   "]
    assert b == Minesweeper.annotate(clean(b))
  end

  test "board full of mines" do
    b = ["***",
         "***",
         "***"]
    assert b == Minesweeper.annotate(clean(b))
  end

  test "surrounded" do
    b = ["***",
         "*8*",
         "***"]
    assert b == Minesweeper.annotate(clean(b))
  end

  test "horizontal line" do
    b = ["1*2*1"]
    assert b == Minesweeper.annotate(clean(b))
  end

  test "vertical line" do
    b = ["1",
         "*",
         "2",
         "*",
         "1"]
    assert b == Minesweeper.annotate(clean(b))
  end

  test "cross" do
    b = [" 2*2 ",
         "25*52",
         "*****",
         "25*52",
         " 2*2 "]
    assert b == Minesweeper.annotate(clean(b))
  end        
end
