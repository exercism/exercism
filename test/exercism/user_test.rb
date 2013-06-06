require './test/mongo_helper'
require 'exercism/user'
require 'exercism/exercise'

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

end

