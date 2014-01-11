Code.load_file("list_ops.exs")
ExUnit.start

defmodule ListOpsTest do
  alias ListOps, as: L

  use ExUnit.Case, async: true

  defp odd?(n), do: rem(n, 2) == 1

  test "count of empty list" do
    assert 0 == L.count([])
  end

  test "count of normal list" do
    assert 4 == L.count([1,3,5,7])
  end

  test "count of huge list" do
    assert 1_000_000 == L.count(Enum.to_list(1..1_000_000))
  end

  test "reverse of empty list" do
    assert [] == L.reverse([])
  end

  test "reverse of normal list" do
    assert [7,5,3,1] == L.reverse([1,3,5,7])
  end

  test "reverse of huge list" do
    assert Enum.to_list(1_000_000..1) == L.reverse(Enum.to_list(1..1_000_000))
  end

  test "map of empty list" do
    assert [] == L.map([], &(&1+1))
  end

  test "map of normal list" do
    assert [2,4,6,8] == L.map([1,3,5,7], &(&1+1))
  end

  test "map of huge list" do
    assert Enum.to_list(2..1_000_001) ==
      L.map(Enum.to_list(1..1_000_000), &(&1+1))
  end

  test "filter of empty list" do
    assert [] == L.filter([], &odd?/1)
  end

  test "filter of normal list" do
    assert [1,3] == L.filter([1,2,3,4], &odd?/1)
  end

  test "filter of huge list" do
    assert Enum.map(1..500_000, &(&1*2-1)) ==
      L.filter(Enum.to_list(1..1_000_000), &odd?/1)
  end

  test "reduce of empty list" do
    assert 0 == L.reduce([], 0, &(&1+&2))
  end

  test "reduce of normal list" do
    assert 7 == L.reduce([1,2,3,4], -3, &(&1+&2))
  end

  test "reduce of huge list" do
    assert Enum.reduce(1..1_000_000, 0, &(&1+&2)) ==
      L.reduce(Enum.to_list(1..1_000_000), 0, &(&1+&2))
  end

  test "reduce with non-commutative function" do
    assert 0 == L.reduce([1,2,3,4], 10, fn x, acc -> acc - x end)
  end

  test "append of empty lists" do
    assert [] == L.append([], [])
  end

  test "append of empty and non-empty list" do
    assert [1,2,3,4] == L.append([], [1,2,3,4])
  end

  test "append of non-empty and empty list" do
    assert [1,2,3,4] == L.append([1,2,3,4], [])
  end

  test "append of non-empty lists" do
    assert [1,2,3,4,5] == L.append([1,2,3], [4,5])
  end

  test "append of huge lists" do
    assert Enum.to_list(1..2_000_000) ==
      L.append(Enum.to_list(1..1_000_000), Enum.to_list(1_000_001..2_000_000))
  end

  test "concat of empty list of lists" do
    assert [] == L.concat([])
  end

  test "concat of normal list of lists" do
    assert [1,2,3,4,5,6] == L.concat([[1,2],[3],[],[4,5,6]])
  end

  test "concat of huge list of small lists" do
    assert Enum.to_list(1..1_000_000) ==
      L.concat(Enum.map(1..1_000_000, &[&1]))
  end

  test "concat of small list of huge lists" do
    assert Enum.to_list(1..1_000_000) ==
      L.concat(Enum.map(0..9, &Enum.to_list((&1*100_000+1)..((&1+1)*100_000))))
  end
end
