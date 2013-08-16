Code.load_file("raindrops.exs")
ExUnit.start

defmodule RaindropsTest do
  use ExUnit.Case, async: true
  doctest Raindrops

  test "1" do
    assert "1" == Raindrops.convert(1)
  end

  test "3" do
    assert "Pling" == Raindrops.convert(3)
  end

  test "5" do
    assert "Plang" == Raindrops.convert(5)
  end

  test "7" do
    assert "Plong" == Raindrops.convert(7)
  end

  test "6" do
    assert "Pling" == Raindrops.convert(6)
  end

  test "9" do
    assert "Pling" == Raindrops.convert(9)
  end

  test "10" do
    assert "Plang" == Raindrops.convert(10)
  end

  test "14" do
    assert "Plong" == Raindrops.convert(14)
  end

  test "15" do
    assert "PlingPlang" == Raindrops.convert(15)
  end

  test "21" do
    assert "PlingPlong" == Raindrops.convert(21)
  end

  test "25" do
    assert "Plang" == Raindrops.convert(25)
  end

  test "35" do
    assert "PlangPlong" == Raindrops.convert(35)
  end

  test "49" do
    assert "Plong" == Raindrops.convert(49)
  end

  test "52" do
    assert "52" == Raindrops.convert(52)
  end

  test "105" do
    assert "PlingPlangPlong" == Raindrops.convert(105)
  end

  test "12121" do
    assert "12121" == Raindrops.convert(12121)
  end
end
