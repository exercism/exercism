require './test/test_helper'
require 'seed/timeline'
require 'seed/attempt'
require 'seed/exercise'
require 'seed/trail'
require 'exercism/locale'

class SeedTrailTest < Minitest::Test
  class FakePythonCurriculum
    def slugs
      %w(one two three four five six seven)
    end

    def locale
      @locale ||= Locale.new('python', 'py', 'py')
    end

    def language
      locale.language
    end
  end

  def test_random_size
    sizes = (1..100).map do
      Seed::Trail.new(FakePythonCurriculum.new).size
    end
    refute_equal 1, sizes.uniq.size
    refute sizes.include?(0)
    assert sizes.min >= 1, "expected: at least 1, got: #{sizes.min}"
    assert sizes.max <= 7, "expected: no more than 7, got: #{sizes.max}"
  end

  def test_exercises
    trail = Seed::Trail.new(FakePythonCurriculum.new, size: 3)
    exercises = trail.exercises
    assert_equal %w(one two three), exercises.map(&:slug)
    *completed, current = exercises
    completed.each do |exercise|
      assert_equal 'done', exercise.attempts.last.state
    end
    assert_equal 'pending', current.attempts.last.state
  end
end
