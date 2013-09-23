require './test/test_helper'

require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/trail'

class TrailTest < Minitest::Test

  attr_reader :trail, :one, :two, :go

  def setup
    super 
    @go = Locale.new('go', 'go', 'go')
    @trail = Trail.new(go, ['one', 'two'], '/tmp')
    @one = Exercise.new('go', 'one')
    @two = Exercise.new('go', 'two')
  end

  def test_language
    assert_equal 'go', trail.language
  end

  def test_first_exercise_on_trail
    assert_equal one, trail.first
  end

  def test_catch_up_missed_exercise
    slugs = %w(chicken suit one garden two cake)
    trail = Trail.new(go, slugs, '/tmp')

    exercise = trail.after(two, %w(chicken suit garden))
    assert_equal one, exercise
  end

  def test_after_last_exercise
    assert_nil trail.after(two, %w(one two))
  end
end

