require 'minitest/autorun'
require_relative 'array'

class ArrayTest < MiniTest::Unit::TestCase

  def test_empty_keep
    assert_equal [], [].keep {|e| e < 10}
  end

  def test_keep_everything
    skip
    assert_equal [1, 2, 3], [1, 2, 3].keep {|e| e < 10}
  end

  def test_keep_first_and_last
    skip
    assert_equal [1, 3], [1, 2, 3].keep {|e| e.odd?}
  end

  def test_keep_neither_first_nor_last
    skip
    assert_equal [2, 4], [1, 2, 3, 4, 5].keep {|e| e.even?}
  end

  def test_keep_strings
    skip
    words = %w(apple zebra banana zombies cherimoya zelot)
    result = words.keep {|word| word.start_with?('z')}
    assert_equal %w(zebra zombies zelot), result
  end

  def test_keep_arrays
    skip
    rows = [
      [1, 2, 3],
      [5, 5, 5],
      [5, 1, 2],
      [2, 1, 2],
      [1, 5, 2],
      [2, 2, 1],
      [1, 2, 5]
    ]
    result = rows.keep {|row| row.include?(5)}
    assert_equal [[5, 5, 5], [5, 1, 2], [1, 5, 2], [1, 2, 5]], result
  end

  def test_empty_discard
    skip
    assert_equal [], [].discard {|e| e < 10}
  end

  def test_discard_nothing
    skip
    assert_equal [1, 2, 3], [1, 2, 3].discard {|e| e > 10}
  end

  def test_discard_first_and_last
    skip
    assert_equal [2], [1, 2, 3].discard {|e| e.odd?}
  end

  def test_discard_neither_first_nor_last
    skip
    assert_equal [1, 3, 5], [1, 2, 3, 4, 5].discard {|e| e.even?}
  end

  def test_discard_strings
    skip
    words = %w(apple zebra banana zombies cherimoya zelot)
    result = words.discard {|word| word.start_with?('z')}
    assert_equal %w(apple banana cherimoya), result
  end

  def test_discard_arrays
    skip
    rows = [
      [1, 2, 3],
      [5, 5, 5],
      [5, 1, 2],
      [2, 1, 2],
      [1, 5, 2],
      [2, 2, 1],
      [1, 2, 5]
    ]
    result = rows.discard {|row| row.include?(5)}
    assert_equal [[1, 2, 3], [2, 1, 2], [2, 2, 1]], result
  end

end
