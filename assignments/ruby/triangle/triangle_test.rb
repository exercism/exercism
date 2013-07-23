require 'minitest/autorun'
require_relative 'triangle'

class TriangeTest < MiniTest::Unit::TestCase
  def test_equilateral_triangles_have_equal_sides
    assert_equal :equilateral, Triangle.new(2, 2, 2).kind
  end

  def test_larger_equilateral_triangles_also_have_equal_sides
    skip
    assert_equal :equilateral, Triangle.new(10, 10, 10).kind
  end

  def test_isosceles_triangles_have_last_two_sides_equal
    skip
    assert_equal :isosceles, Triangle.new(3, 4, 4).kind
  end

  def test_isosceles_triangles_have_first_and_last_sides_equal
    skip
    assert_equal :isosceles, Triangle.new(4, 3, 4).kind
  end

  def test_isosceles_triangles_have_two_first_sides_equal
    skip
    assert_equal :isosceles, Triangle.new(4, 4, 3).kind
  end

  def test_isosceles_triangles_have_in_fact_exactly_two_sides_equal
    skip
    assert_equal :isosceles, Triangle.new(10, 10, 2).kind
  end

  def test_scalene_triangles_have_no_equal_sides
    skip
    assert_equal :scalene, Triangle.new(3, 4, 5).kind
  end

  def test_scalene_triangles_have_no_equal_sides_at_a_larger_scale_too
    skip
    assert_equal :scalene, Triangle.new(10, 11, 12).kind
  end

  def test_scalene_triangles_have_no_equal_sides_in_descending_order_either
    skip
    assert_equal :scalene, Triangle.new(5, 4, 2).kind
  end

  def test_very_small_triangles_are_legal
    skip
    assert_equal :scalene, Triangle.new(0.4, 0.6, 0.3).kind
  end

  def test_triangles_with_no_size_are_illegal
    skip
    assert_raises(TriangleError) do
      Triangle.new(0, 0, 0).kind
    end
  end

  def test_triangles_with_negative_sides_are_illegal
    skip
    assert_raises(TriangleError) do
      Triangle.new(3, 4, -5).kind
    end
  end

  def test_triangles_violating_triangle_inequality_are_illegal
    skip
    assert_raises(TriangleError) do
      Triangle.new(1, 1, 3).kind
    end
  end

  def test_triangles_violating_triangle_inequality_are_illegal_2
    skip
    assert_raises(TriangleError) do
      Triangle.new(2, 4, 2).kind
    end
  end

  def test_triangles_violating_triangle_inequality_are_illegal_3
    skip
    assert_raises(TriangleError) do
      Triangle.new(7, 3, 2).kind
    end
  end

end
