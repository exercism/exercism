require 'minitest/autorun'
require_relative 'binary'

class BinarySearchTest < MiniTest::Unit::TestCase

  def test_it_has_list_data
    binary = BinarySearch.new([1, 3, 4, 6, 8, 9, 11])
    assert_equal [1, 3, 4, 6, 8, 9, 11], binary.list
  end

  def test_it_raises_error_for_unsorted_list
    skip
    assert_raises ArgumentError do
      BinarySearch.new([2, 1, 4, 3, 6])
    end
  end

  def test_it_raises_error_for_data_not_in_list
    skip
    assert_raises RuntimeError do
      BinarySearch.new([1, 3, 6]).search_for(2)
    end
  end

  def test_it_finds_position_of_middle_item
    skip
    binary = BinarySearch.new([1, 3, 4, 6, 8, 9, 11])
    assert_equal 3, binary.middle
  end

  def test_it_finds_position_of_search_data
    skip
    binary = BinarySearch.new([1, 3, 4, 6, 8, 9, 11])
    assert_equal 5, binary.search_for(9)
  end

  def test_it_finds_position_in_a_larger_list
    skip
    binary = BinarySearch.new([1, 3, 5, 8, 13, 21, 34, 55, 89, 144])
    assert_equal 1, binary.search_for(3)
    assert_equal 7, binary.search_for(55)
  end

  def test_it_finds_correct_position_in_a_list_with_an_even_number_of_elements
    skip
    binary = BinarySearch.new([1, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377])
    assert_equal 5, binary.search_for(21)
    assert_equal 6, binary.search_for(34)
  end
end
