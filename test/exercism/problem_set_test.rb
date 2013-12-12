require './test/test_helper'
require 'exercism/exercise'
require 'exercism/problem_set'

class ProblemSetTest < Minitest::Test
  class FakeUser
    include ProblemSet

    def current
      {'ruby' => 'cake', 'python' => 'eggs', 'go' => 'light'}
    end

    def completed
      {'ruby' => ['shoe', 'lion'], 'python' => ['ham']}
    end
  end

  attr_reader :alice
  def setup
    @alice = FakeUser.new
  end

  def test_completed_exercises
    shoe, lion = alice.completed_exercises['ruby']
    ham = alice.completed_exercises['python'].first
    assert_equal Exercise.new('ruby', 'shoe'), shoe
    assert_equal Exercise.new('ruby', 'lion'), lion
    assert_equal Exercise.new('python', 'ham'), ham
  end

  def test_completed_p
    assert alice.completed?(Exercise.new('ruby', 'shoe')), 'shoe'
    assert alice.completed?(Exercise.new('ruby', 'lion')), 'lion'
    refute alice.completed?(Exercise.new('ruby', 'cake')), 'cake'
    refute alice.completed?(Exercise.new('ruby', 'pill')), 'pill'
  end

  def test_latest_in_language
    ham = Exercise.new('python', 'ham')
    assert_equal ham, alice.latest_in('python')

    lion = Exercise.new('ruby', 'lion')
    assert_equal lion, alice.latest_in('ruby')

    assert_nil alice.latest_in('haskell')
  end
end

