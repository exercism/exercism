Code.load_file("custom_set.exs")
ExUnit.start

defmodule CustomSetTest do
  use ExUnit.Case
  doctest CustomSet

  # Tip: to make your set work with the Set module be sure that your set value
  # is a tuple with as first element `CustomSet`. A record with tag `CustomSet`
  # will meet this requirement.

  test "delete" do
    assert Set.equal?(Set.delete(CustomSet.new([3,2,1]), 2), CustomSet.new([1,3]))
    assert Set.equal?(Set.delete(CustomSet.new([3,2,1]), 4), CustomSet.new([1,2,3]))
    assert Set.equal?(Set.delete(CustomSet.new([3,2,1]), 2.0), CustomSet.new([1,2,3]))
  end

  test "difference" do
    assert Set.equal?(
      Set.difference(CustomSet.new([1,2,3]), CustomSet.new([2,4])),
      CustomSet.new([1,3]))
    assert Set.equal?(
      Set.difference(CustomSet.new([1,2.0,3]), CustomSet.new([2,4])),
      CustomSet.new([1,2.0,3]))
  end

  test "disjoint?" do
    assert Set.disjoint?(CustomSet.new([1,2]), CustomSet.new([3,4]))
    refute Set.disjoint?(CustomSet.new([1,2]), CustomSet.new([2,3]))
    assert Set.disjoint?(CustomSet.new([1.0,2.0]), CustomSet.new([2,3]))
    assert Set.disjoint?(CustomSet.new, CustomSet.new)
  end

  test "empty" do
    assert Set.equal?(Set.empty(CustomSet.new([1,2])), CustomSet.new)
    assert Set.equal?(Set.empty(CustomSet.new), CustomSet.new)
  end

  test "intersection" do
    assert Set.equal?(
      Set.intersection(CustomSet.new([:a, :b, :c]), CustomSet.new([:a, :c, :d])),
      CustomSet.new([:a, :c]))
    assert Set.equal?(
      Set.intersection(CustomSet.new([1, 2, 3]), CustomSet.new([1.0, 2.0, 3])),
      CustomSet.new([3]))
  end

  test "member?" do
    assert Set.member?(CustomSet.new([1,2,3]), 2)
    assert Set.member?(CustomSet.new(1..3), 2)
    refute Set.member?(CustomSet.new(1..3), 2.0)
    refute Set.member?(CustomSet.new(1..3), 4)
  end

  test "put" do
    assert Set.equal?(
      Set.put(CustomSet.new([1,2,4]), 3),
      CustomSet.new([1,2,3,4]))
    assert Set.equal?(
      Set.put(CustomSet.new([1,2,3]), 3),
      CustomSet.new([1,2,3]))
    assert Set.equal?(
      Set.put(CustomSet.new([1,2,3]), 3.0),
      CustomSet.new([1,2,3,3.0]))
  end

  test "size" do
    assert Set.size(CustomSet.new) == 0
    assert Set.size(CustomSet.new([1,2,3])) == 3
    assert Set.size(CustomSet.new([1,2,3,2])) == 3
  end

  test "subset?" do
    assert Set.subset?(CustomSet.new([1,2,3]), CustomSet.new([1,2,3]))
    assert Set.subset?(CustomSet.new([1,2,3]), CustomSet.new([4,1,2,3]))
    refute Set.subset?(CustomSet.new([1,2,3]), CustomSet.new([4,1,3]))
    refute Set.subset?(CustomSet.new([1,2,3.0]), CustomSet.new([1,2,3,4]))
    assert Set.subset?(CustomSet.new, CustomSet.new([4,1,3]))
    assert Set.subset?(CustomSet.new, CustomSet.new)
  end

  test "to_list" do
    assert Enum.sort(Set.to_list(CustomSet.new)) == []
    assert Enum.sort(Set.to_list(CustomSet.new([3,1,2]))) == [1,2,3]
    assert Enum.sort(Set.to_list(CustomSet.new([3,1,2,1]))) == [1,2,3]
  end

  test "union" do
    assert Set.equal?(
      CustomSet.union(CustomSet.new([1,3]), CustomSet.new([2])),
      CustomSet.new([3,2,1]))
    assert Set.equal?(
      CustomSet.union(CustomSet.new([1,3]), CustomSet.new([2,3.0])),
      CustomSet.new([3.0,3,2,1]))
    assert Set.equal?(
      CustomSet.union(CustomSet.new([1,3]), CustomSet.new),
      CustomSet.new([3,1]))
    assert Set.equal?(
      CustomSet.union(CustomSet.new, CustomSet.new([2])),
      CustomSet.new([2]))
    assert Set.equal?(
      CustomSet.union(CustomSet.new, CustomSet.new),
      CustomSet.new([]))
  end

  test "inspect" do
    assert inspect(CustomSet.new) == "#<CustomSet []>"
    assert inspect(CustomSet.new([1,3,2])) == "#<CustomSet [1, 2, 3]>"
    # Weird ordering due to how Elixir/Erlang considers binaries, numbers and
    # atoms to be ordered.
    assert inspect(CustomSet.new(["A",:b,?C])) == "#<CustomSet [67, :b, \"A\"]>"
  end
end

