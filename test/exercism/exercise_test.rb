require './test/test_helper'
require 'exercism/exercise'

class ExerciseTest < Minitest::Test
  def test_exercise_attributes
    exercise = Exercise.new('go', 'one')

    assert_equal 'go', exercise.language
    assert_equal 'one', exercise.slug
  end

  def test_exercise_name
    exercise = Exercise.new('go', 'one')
    assert_equal 'One', exercise.name
  end

  def test_compound_exercise_name
    exercise = Exercise.new('go', 'one-and-two')
    assert_equal 'One And Two', exercise.name
  end

  def test_exercise_to_s
    exercise = Exercise.new('go', 'one')
    assert_equal 'Exercise: one (Go)', exercise.to_s
  end
end

