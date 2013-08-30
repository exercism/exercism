require 'minitest/autorun'
require_relative 'array'

class ArrayTest < MiniTest::Unit::TestCase

  def test_empty_accumulation
    assert_equal [], [].accumulate {|e| e * e}
  end

  def test_accumulate_squares
    skip
    result = [1, 2, 3].accumulate { |number|
      number * number
    }
    assert_equal [1, 4, 9], result
  end

  def test_accumulate_upcases
    skip
    result = %w(hello world).accumulate { |word|
      word.upcase
    }
    assert_equal %(HELLO WORLD), result
  end

  def test_accumulate_reversed_strings
    skip
    result = %w(the quick brown fox etc).accumulate { |word|
      word.reverse
    }
    assert_equal %w(eht kciuq nworb xof cte), result
  end

  def test_accumulate_recursively
    skip
    result = %w(a b c).accumulate { |char|
      %w(1 2 3).accumulate { |digit|
        "#{char}#{digit}"
      }
    }
    assert_equal [%w(a1 a2 a3), %w(b1 b2 b3), %w(c1 c2 c3)], result
  end

end
