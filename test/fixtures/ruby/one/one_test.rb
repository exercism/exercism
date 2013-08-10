require 'minitest/autorun'
require_relative 'example'
class OneTest < Minitest::Test
  def test_one
    assert_equal 1, One.value
  end
end
