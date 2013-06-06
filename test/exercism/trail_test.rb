require './test/test_helper'
require 'exercism/language'
require 'exercism/exercise'
require 'exercism/trail'

class TrailTest < MiniTest::Unit::TestCase

  def test_successive_exercises
    nong = Language.new('nong', 'no', 'not')
    trail = Trail.new(nong, ['one', 'two'], '/tmp')
    one = Exercise.new('nong', 'one')
    two = Exercise.new('nong', 'two')
    assert_equal two, trail.after(one)
  end

end
