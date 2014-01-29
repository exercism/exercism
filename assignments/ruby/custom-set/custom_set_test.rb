require 'minitest/autorun'
require_relative 'custom_set'

class CustomSetTest < MiniTest::Unit::TestCase

  def test_equal
    assert_equal CustomSet.new([1, 3]), CustomSet.new([3, 1])
  end

  def test_delete
    assert_equal CustomSet.new([1,3]), CustomSet.new([3,2,1]).delete(2)
    assert_equal CustomSet.new([1,2,3]), CustomSet.new([3,2,1]).delete(4)
    assert_equal CustomSet.new([1,2,3]), CustomSet.new([3,2,1]).delete(2.0)
  end

  def test_difference
    assert_equal CustomSet.new([1,3]),
      CustomSet.new([1,2,3]).difference(CustomSet.new([2,4]))

    assert_equal CustomSet.new([1,2.0,3]),
      CustomSet.new([1,2.0,3]).difference(CustomSet.new([2,4]))
  end

  def test_disjoint?
    assert CustomSet.new([1,2]).disjoint?(CustomSet.new([3,4]))
    refute CustomSet.new([1,2]).disjoint?(CustomSet.new([2,3]))
    assert CustomSet.new([1.0,2.0]).disjoint?(CustomSet.new([2,3]))
    assert CustomSet.new.disjoint?(CustomSet.new)
  end

  def test_empty
    assert_equal CustomSet.new, CustomSet.new([1,2]).empty
    assert_equal CustomSet.new, CustomSet.new.empty
  end

  def test_intersection
    assert_equal CustomSet.new([:a, :c]),
      CustomSet.new([:a, :b, :c]).intersection(CustomSet.new([:a, :c, :d]))

    assert_equal CustomSet.new([3]),
      CustomSet.new([1, 2, 3]).intersection(CustomSet.new([1.0, 2.0, 3]))
  end

  def test_member?
    assert CustomSet.new([1,2,3]).member?(2)
    assert CustomSet.new(1..3).member?(2)
    refute CustomSet.new(1..3).member?(2.0)
    refute CustomSet.new(1..3).member?(4)
  end

  def test_put
    assert_equal CustomSet.new([1,2,3,4]),
      CustomSet.new([1,2,4]).put(3)

    assert_equal CustomSet.new([1,2,3]),
      CustomSet.new([1,2,3]).put(3)

    assert_equal CustomSet.new([1,2,3,3.0]),
      CustomSet.new([1,2,3]).put(3.0)
  end

  def test_size
    assert_equal 0, CustomSet.new.size
    assert_equal 3, CustomSet.new([1,2,3]).size
    assert_equal 3, CustomSet.new([1,2,3,2]).size
  end

  def test_subset?
    assert CustomSet.new([1,2,3]).subset?(CustomSet.new([1,2,3]))
    assert CustomSet.new([4,1,2,3]).subset?(CustomSet.new([1,2,3]))
    refute CustomSet.new([4,1,3]).subset?(CustomSet.new([1,2,3]))
    refute CustomSet.new([1,2,3,4]).subset?(CustomSet.new([1,2,3.0]))
    assert CustomSet.new([4,1,3]).subset?(CustomSet.new)
    assert CustomSet.new.subset?(CustomSet.new)
  end

  def test_to_list
    assert_equal [], CustomSet.new.to_list.sort
    assert_equal [1,2,3], CustomSet.new([3,1,2]).to_list.sort
    assert_equal [1,2,3], CustomSet.new([3,1,2,1]).to_list.sort
  end

  def test_union
    assert_equal CustomSet.new([3,2,1]),
      CustomSet.new([1,3]).union(CustomSet.new([2]))
    assert_equal CustomSet.new([3.0,3,2,1]),
      CustomSet.new([1,3]).union(CustomSet.new([2,3.0]))
    assert_equal CustomSet.new([3,1]),
      CustomSet.new([1,3]).union(CustomSet.new)
    assert_equal CustomSet.new([2]),
      CustomSet.new([2]).union(CustomSet.new)
    assert_equal CustomSet.new([]),
      CustomSet.new.union(CustomSet.new)
  end

end
