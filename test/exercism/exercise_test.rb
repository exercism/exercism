require './test/test_helper'

require 'exercism/exercise'

class ExerciseTest < Minitest::Test

  def test_exercise_attributes
    exercise = Exercise.new('nong', 'one')

    assert_equal 'nong', exercise.language
    assert_equal 'one', exercise.slug
  end

  def test_exercise_name
    exercise = Exercise.new('nong', 'one-and-two')

    assert_equal 'One And Two', exercise.name
  end

  def test_exercise_to_s
    exercise = Exercise.new('nong', 'one')

    assert_equal '#<Exercise nong:one>', exercise.to_s
  end

end
