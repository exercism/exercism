require 'minitest/autorun'
require_relative 'example'
class TwoTest < Minitest::Test
  def test_two
    assert_equal 2, Two.value
  end
end
