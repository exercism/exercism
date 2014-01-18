if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("triangle.exs")
end

ExUnit.start

defmodule TriangleTest do
  use ExUnit.Case, async: true

  test "equilateral triangles have equal sides" do
    assert { :ok, :equilateral } == Triangle.kind(2, 2, 2)
  end

  test "larger equilateral triangles also have equal sides" do
    assert { :ok, :equilateral } == Triangle.kind(10, 10, 10)
  end

  test "isosceles triangles have last two sides equal" do
    assert { :ok, :isosceles } == Triangle.kind(3, 4, 4)
  end

  test "isosceles triangles have first and last sides equal" do
    assert { :ok, :isosceles } == Triangle.kind(4, 3, 4)
  end

  test "isosceles triangles have two first sides equal" do
    assert { :ok, :isosceles } == Triangle.kind(4, 4, 3)
  end

  test "isosceles triangles have in fact exactly two sides equal" do
    assert { :ok, :isosceles } == Triangle.kind(10, 10, 2)
  end

  test "scalene triangles have no equal sides" do
    assert { :ok, :scalene } == Triangle.kind(3, 4, 5)
  end

  test "scalene triangles have no equal sides at a larger scale too" do
    assert { :ok, :scalene } == Triangle.kind(10, 11, 12)
  end

  test "scalene triangles have no equal sides in descending order either" do
    assert { :ok, :scalene } == Triangle.kind(5, 4, 2)
  end

  test "very small triangles are legal" do
    assert { :ok, :scalene } == Triangle.kind(0.4, 0.6, 0.3)
  end

  test "triangles with no size are illegal" do
    assert { :error, "all side lengths must be positive" } == Triangle.kind(0, 0, 0)
  end

  test "triangles with negative sides are illegal" do
    assert { :error, "all side lengths must be positive" } == Triangle.kind(3, 4, -5)
  end

  test "triangles violating triangle inequality are illegal" do
    assert { :error, "side lengths violate triangle inequality" } == Triangle.kind(1, 1, 3)
  end

  test "triangles violating triangle inequality are illegal 2" do
    assert { :error, "side lengths violate triangle inequality" } == Triangle.kind(2, 4, 2)
  end

  test "triangles violating triangle inequality are illegal 3" do
    assert { :error, "side lengths violate triangle inequality" } == Triangle.kind(7, 3, 2)
  end
end

