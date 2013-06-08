require './test/mongo_helper'
require 'exercism/user'
require 'exercism/exercise'
require 'exercism/locale'
require 'exercism/trail'
require 'exercism/submission'

class UserTest < MiniTest::Unit::TestCase

  def teardown
    Mongoid.reset
  end

  def test_identical_users_are_identical
    attributes = {
      username: 'alice',
      current: {'nong' => 'one'},
    }
    user1 = User.new(attributes)
    user2 = User.new(attributes)
    assert_equal user1, user2
  end

  def test_user_on_a_single_trail
    user = User.new(current: {'nong' => 'one'})
    ex = Exercise.new('nong', 'one')
    assert_equal [ex], user.current_exercises
  end

  def test_user_on_multiple_trails
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})
    ex1 = Exercise.new('nong', 'one')
    ex2 = Exercise.new('femp', 'two')
    assert_equal [ex1, ex2], user.current_exercises
  end

  def test_user_knows_what_they_are_doing
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})
    assert user.doing?('femp')
  end

  def test_user_knows_what_they_are_not_doing
    user = User.new(current: {'nong' => 'one'})
    assert !user.doing?('femp')
  end

  def test_user_finds_current_exercise_for_a_language
    user = User.new(current: {'nong' => 'one', 'femp' => 'two'})

    assert_equal Exercise.new('femp', 'two'), user.current_on('femp')
  end

  def test_user_completes_an_exercise
    user = User.new(current: {'nong' => 'one'})
    nong = Locale.new('nong', 'no', 'not')
    trail = Trail.new(nong, ['one', 'two'], '/tmp')

    one = Exercise.new('nong', 'one')
    two = Exercise.new('nong', 'two')
    user.complete!(one, on: trail)
    assert user.completed?(one), 'Expected to have completed nong:one'
    assert_equal [two], user.current_exercises
  end

end

