require './test/mongo_helper'

require 'exercism/signup'
require 'exercism/user'
require 'exercism/locale'
require 'exercism/trail'
require 'exercism/exercise'

class SignupTest < Minitest::Test

  attr_reader :user, :trail
  def setup
    @user = User.create
    locale = Locale.new('nong', 'no', 'not')
    @trail = Trail.new(locale, ['one', 'two'], '/tmp')
  end

  def teardown
    Mongoid.reset
  end

  def test_user_gets_new_exercise
    assert_equal [], user.current_exercises
    Signup.new(user, trail).perform
    one = Exercise.new('nong', 'one')
    assert_equal [one], user.reload.current_exercises
  end

  def test_user_can_work_trails_concurrently
    femp = Locale.new('femp', 'fp', 'fpt')
    trail2 = Trail.new(femp, ['one', 'two'], '/tmp')

    Signup.new(user, trail).perform
    Signup.new(user, trail2).perform
    one = Exercise.new('nong', 'one')
    two = Exercise.new('femp', 'one')
    assert_equal [one, two], user.reload.current_exercises
  end

  def test_signing_up_for_same_trail_doesnt_reset_it
    one = Exercise.new('nong', 'one')
    two = Exercise.new('nong', 'two')
    user.do!(two)
    Signup.new(user, trail).perform
    assert_equal [two], user.reload.current_exercises
  end

end


