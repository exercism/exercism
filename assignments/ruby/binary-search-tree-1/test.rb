require 'minitest/autorun'
require 'minitest/pride'
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

  def test_small_tree
    skip
    four = Bst.new 4
    four.insert 5
    four.insert 3
    assert_equal 4, four.data
    assert_equal 5, four.right.data
    assert_equal 3, four.left.data
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
end
