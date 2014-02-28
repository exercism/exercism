if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("sublist.exs")
end

ExUnit.start

defmodule TeenagerTest do
  use ExUnit.Case, async: true
  doctest Sublist

  test "empty equals empty" do
    assert Sublist.compare([], []) == :equal
  end

  test "empty is a sublist of anything" do
    assert Sublist.compare([], [nil]) == :sublist
  end

  test "anything is a superlist of empty" do
    assert Sublist.compare([nil], []) == :superlist
  end

  test "1 is not 2" do
    assert Sublist.compare([1], [2]) == :unequal
  end

  test "comparing massive equal lists" do
    l = Enum.to_list(1..1_000_000)
    assert Sublist.compare(l, l) == :equal
  end

  test "sublist at start" do
    assert Sublist.compare([1,2,3],[1,2,3,4,5]) == :sublist
  end

  test "sublist in middle" do
    assert Sublist.compare([3,2,1],[5,4,3,2,1]) == :sublist
  end
  
  test "sublist at end" do
    assert Sublist.compare([3,4,5],[1,2,3,4,5]) == :sublist
  end

  test "partially matching sublist at start" do
    assert Sublist.compare([1,1,2], [1,1,1,2]) == :sublist
  end

  test "sublist early in huge list" do
    assert Sublist.compare([3,4,5], Enum.to_list(1..1_000_000)) == :sublist
  end
  
  test "huge sublist not in huge list" do
    assert Sublist.compare(Enum.to_list(10..1_000_001),
                           Enum.to_list(1..1_000_000))
           == :unequal
  end
  
  test "superlist at start" do
    assert Sublist.compare([1,2,3,4,5],[1,2,3]) == :superlist
  end

  test "superlist in middle" do
    assert Sublist.compare([5,4,3,2,1],[3,2,1]) == :superlist
  end
  
  test "superlist at end" do
    assert Sublist.compare([1,2,3,4,5],[3,4,5]) == :superlist
  end
  
  test "partially matching superlist at start" do
    assert Sublist.compare([1,1,1,2], [1,1,2]) == :superlist
  end

  test "superlist early in huge list" do
    assert Sublist.compare(Enum.to_list(1..1_000_000), [3,4,5]) == :superlist
  end

  test "strict equality needed" do
    assert Sublist.compare([1], [1.0, 2]) == :unequal
  end

  test "recurring values sublist" do
    assert Sublist.compare([1,2,1,2,3], [1,2,3,1,2,1,2,3,2,1]) == :sublist
  end

  test "recurring values unequal" do
    assert Sublist.compare([1,2,1,2,3], [1,2,3,1,2,3,2,3,2,1]) == :unequal
  end
end
