require 'minitest/autorun'
require_relative 'bst'

class BstTest < MiniTest::Unit::TestCase
  def test_data_is_retained
    assert_equal 4, Bst.new(4).data
  end

  def test_inserting_less
    skip
    four = Bst.new 4
    four.insert 2
    assert_equal 4, four.data
    assert_equal 2, four.left.data
  end

  def test_inserting_same
    skip
    four = Bst.new 4
    four.insert 4
    assert_equal 4, four.data
    assert_equal 4, four.left.data
  end

  def test_inserting_right
    skip
    four = Bst.new 4
    four.insert 5
    assert_equal 4, four.data
    assert_equal 5, four.right.data
  end

  def test_complex_tree
    skip
    four = Bst.new 4
    four.insert 2
    four.insert 6
    four.insert 1
    four.insert 3
    four.insert 7
    four.insert 5
    assert_equal 4, four.data
    assert_equal 2, four.left.data
    assert_equal 1, four.left.left.data
    assert_equal 3, four.left.right.data
    assert_equal 6, four.right.data
    assert_equal 5, four.right.left.data
    assert_equal 7, four.right.right.data
  end

  def record_all_data(bst)
    all_data = []
    bst.each { |data| all_data << data }
    all_data
  end

  def test_iterating_one_element
    skip
    assert_equal [4], record_all_data(Bst.new 4)
  end

  def test_iterating_over_smaller_element
    skip
    four = Bst.new 4
    four.insert 2
    assert_equal [2, 4], record_all_data(four)
  end

  def test_iterating_over_larger_element
    skip
    four = Bst.new 4
    four.insert 5
    assert_equal [4, 5], record_all_data(four)
  end

  def test_iterating_over_complex_tree
    skip
    four = Bst.new 4
    four.insert 2
    four.insert 1
    four.insert 3
    four.insert 6
    four.insert 7
    four.insert 5
    assert_equal [1, 2, 3, 4, 5, 6, 7], record_all_data(four)
  end
end
