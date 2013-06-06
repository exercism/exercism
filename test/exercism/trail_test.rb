require './test/test_helper'
require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/trail'

class TrailTest < MiniTest::Unit::TestCase

  attr_reader :trail, :one, :two
  def setup
    nong = Locale.new('nong', 'no', 'not')
    @trail = Trail.new(nong, ['one', 'two'], '/tmp')
    @one = Exercise.new('nong', 'one')
    @two = Exercise.new('nong', 'two')
  end

  def test_language
    assert_equal 'nong', trail.language
  end

  def test_first_exercise_on_trail
    assert_equal one, trail.first
  end

  def test_successive_exercises
    assert_equal two, trail.after(one)
  end

end

