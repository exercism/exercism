Code.load_file("strain.exs")
ExUnit.start

defmodule StrainTest do
  use ExUnit.Case, async: true

  test "empty keep" do
    assert [] == Strain.keep([], &(&1 < 10))
  end

  test "keep everything" do
    assert [1, 2, 3] == Strain.keep([1, 2, 3], &(&1 < 10))
  end

  test "keep first and last" do
    assert [1, 3] == Strain.keep([1, 2, 3], &(Integer.odd?(&1)))
  end

  test "keep neither first nor last" do
    assert [2, 4] == Strain.keep([1, 2, 3, 4, 5], &(Integer.even?(&1)))
  end

  test "keep strings" do
    words = %w(apple zebra banana zombies cherimoya zelot)
    assert %w(zebra zombies zelot) == Strain.keep(words, &(String.starts_with?(&1, "z")))
  end

  test "keep lists" do
    rows = [
      [1, 2, 3],
      [5, 5, 5],
      [5, 1, 2],
      [2, 1, 2],
      [1, 5, 2],
      [2, 2, 1],
      [1, 2, 5],
    ]

    assert [[5, 1, 2], [2, 1, 2], [1, 5, 2]] == Strain.keep(rows, &(List.last(&1) == 2))
  end

  test "keep from ranges" do
    assert [2, 4] == Strain.keep(1..5, &(rem(&1, 2) == 0))
  end

  test "empty discard" do
    assert [] == Strain.discard([], &(&1 < 10))
  end

  test "discard nothing" do
    assert [1, 2, 3] == Strain.discard([1, 2, 3], &(&1 > 10))
  end

  test "discard first and last" do
    assert [2] == Strain.discard([1, 2, 3], &(Integer.odd?(&1)))
  end

  test "discard neither first nor last" do
    assert [1, 3, 5] == Strain.discard([1, 2, 3, 4, 5], &(Integer.even?(&1)))
  end

  test "discard strings" do
    words = %w(apple zebra banana zombies cherimoya zelot)
    assert %w(apple banana cherimoya) == Strain.discard(words, &(String.starts_with?(&1, "z")))
  end

  test "discard arrays" do
    rows = [
      [1, 2, 3],
      [5, 5, 5],
      [5, 1, 2],
      [2, 1, 2],
      [1, 5, 2],
      [2, 2, 1],
      [1, 2, 5],
    ]

    assert [[1, 2, 3], [5, 5, 5], [2, 2, 1], [1, 2, 5]] == Strain.discard(rows, &(List.last(&1) == 2))
  end

  test "discard from ranges" do
    assert [1, 3, 5] == Strain.discard(1..5, &(rem(&1, 2) == 0))

  end

end