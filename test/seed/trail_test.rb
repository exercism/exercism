require './test/test_helper'
require 'seed/timeline'
require 'seed/attempt'
require 'seed/exercise'
require 'seed/trail'

class SeedTrailTest < MiniTest::Unit::TestCase
  def test_random_size
    sizes = (1..100).map do
      Seed::Trail.new('python').size
    end
    refute_equal 1, sizes.uniq.size
    refute sizes.include?(0)
    assert sizes.min >= 1, "expected: at least 1, got: #{sizes.min}"
    assert sizes.max <= 5, "expected: no more than 5, got: #{sizes.max}"
  end

  def test_exercises
    trail = Seed::Trail.new('python', size: 3)
    exercises = trail.exercises
    assert_equal %w(bob anagram leap), exercises.map(&:slug)
    *completed, current = exercises
    completed.each do |exercise|
      assert_equal 'done', exercise.attempts.last.state
    end
    assert_equal 'pending', current.attempts.last.state
  end
end
