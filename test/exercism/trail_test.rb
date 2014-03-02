require './test/test_helper'

require 'exercism/named'
require 'exercism/exercise'
require 'exercism/trail'

class TrailTest < MiniTest::Unit::TestCase
  def test_exercises_get_reasonable_name
    trail = Trail.new('Common Lisp', ['one'])
    assert_equal 'common-lisp', trail.exercises.first.language
  end
end
