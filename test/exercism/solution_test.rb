require './test/test_helper'
require 'exercism/exercise'
require 'exercism/locale'
require 'exercism/code'
require 'exercism/problem_set'
require 'exercism/solution'

class SolutionTest < Minitest::Test
  class FakeUser
    include ProblemSet

    def current
      {'ruby' => 'button'}
    end

    def completed
      {'ruby' => ['hypothesis', 'tree'], 'python' => ['gyroscope']}
    end
  end

  def locales
    [
      Locale.new('ruby', 'rb', 'rb'),
      Locale.new('python', 'py', 'py')
    ]
  end

  attr_reader :alice
  def setup
    super
    @alice = FakeUser.new
  end

  def test_identify_current_exercise
    exercise = Exercise.new('ruby', 'button')
    code = Code.new('/some/path/button/file.rb', locales)
    solution = Solution.new(alice, code)
    assert_equal exercise, solution.exercise
  end

  def test_identify_available_exercise_on_unstarted_trail
    exercise = Exercise.new('python', 'tissue')
    code = Code.new('/some/path/tissue/file.py', locales)
    solution = Solution.new(alice, code)
    assert_equal exercise, solution.exercise
  end

  def test_assume_current_exercise
    exercise = Exercise.new('ruby', 'button')
    code = Code.new('file.rb', locales)
    solution = Solution.new(alice, code)
    assert_equal exercise, solution.exercise
  end

  def test_identify_completed_exercise
    exercise = Exercise.new('ruby', 'hypothesis')
    code = Code.new('/some/path/hypothesis/file.rb', locales)
    solution = Solution.new(alice, code)
    assert_equal exercise, solution.exercise
  end

  def test_blows_up_on_future_exercise
    code = Code.new('/some/path/goat/file.rb', locales)
    solution = Solution.new(alice, code)
    assert_raises Exercism::UnavailableExercise do
      solution.exercise
    end
  end

end

