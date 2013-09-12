require './test/test_helper'
require 'seed/exercise'
require 'seed/attempt'
require 'seed/timeline'

class SeedExerciseTest < Minitest::Test

  def test_random_size
    sizes = (1..100).map do
      Seed::Exercise.new('ruby', 'boat').size
    end
    refute_equal 1, sizes.uniq.size
    refute sizes.include?(0)
    assert sizes.min >= 1, "expected: at least one, got: #{sizes.min}"
    assert sizes.max <= 12, "expected: no more than 12, got: #{sizes.max}"
  end

  def test_completed_exercise
    exercise = Seed::Exercise.new('ruby', 'cake', attempts: 3)

    attempts = exercise.attempts
    assert_equal 3, attempts.size
    *superseded, done = attempts
    superseded.each do |attempt|
      assert_equal 'superseded', attempt.state
    end
    assert_equal 'done', done.state
  end

  def test_current_exercise
    exercise = Seed::Exercise.new('ruby', 'shoe', attempts: 3, done: false)

    *superseded, pending = exercise.attempts
    superseded.each do |attempt|
      assert_equal 'superseded', attempt.state
    end
    assert_equal 'pending', pending.state
  end
end
