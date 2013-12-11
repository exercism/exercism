Code.load_file("pythagorean_triplet.exs")
ExUnit.start

defmodule PythagoreanTripletTest do
  use ExUnit.Case, async: true

  test "sum" do
    triplet = [3, 4, 5]
    assert 12 == Triplet.sum(triplet)
  end

  test "product" do
    triplet = [3, 4, 5]
    assert 60 == Triplet.product(triplet)
  end

  test "pythagorean" do
    triplet = [3, 4, 5]
    assert Triplet.pythagorean?(triplet)
  end

  test "not pythagorean" do
    triplet = [5, 6, 7]
    assert !Triplet.pythagorean?(triplet)
  end

  test "triplets up to 10" do
    triplets = Triplet.generate(10)
    assert [60, 480] == Enum.map(triplets, &(Triplet.product(&1)))
  end

  test "triplets from 11 up to 20" do
    triplets = Triplet.generate(11, 20)
    assert [3840] == Enum.map(triplets, &(Triplet.product(&1)))
  end

  test "triplets where sum is 180 and max factor is 100" do
    triplets = Triplet.generate(1, 100, 180)
    assert [118080, 168480, 202500] == Enum.map(triplets, &(Triplet.product(&1)))
  end


end