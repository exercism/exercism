require 'minitest/autorun'
require_relative 'example'
class ThreeTest < Minitest::Test
  def test_three
    assert_equal 3, Three.value
  end
end
