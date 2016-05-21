require_relative '../../test_helper'
require_relative '../../../app/presenters/profile'
require_relative '../../api_helper'
require 'mocha/setup'

class PresentersProfileTest < Minitest::Test
  def setup
    @user = User.new(username: "fred")
  end

  def test_shared_profile_with_guest
    guest = Guest.new
    assert ExercismWeb::Presenters::Profile.new(@user, guest, shared: true).access?(:exercise)
  end

  def test_shared_profile_with_another_user_having_no_exercise_access
    current_user = User.new(username: "rudy")
    current_user.stubs(:access?).with(:exercise).returns(false)
    assert ExercismWeb::Presenters::Profile.new(@user, current_user, shared: true).access?(:exercise)
  end

  def test_shared_profile_with_another_user_having_exercise_access
    current_user = User.new(username: "rudy")
    current_user.stubs(:access?).with(:exercise).returns(true)
    assert ExercismWeb::Presenters::Profile.new(@user, current_user, shared: true).access?(:exercise)
  end

  def test_private_profile_with_another_user_having_no_exercise_access
    current_user = User.new(username: "rudy")
    current_user.expects(:access?).with(:exercise).returns(false)
    refute ExercismWeb::Presenters::Profile.new(@user, current_user).access?(:exercise)
  end

  def test_private_profile_with_another_user_having_exercise_access
    current_user = User.new(username: "rudy")
    current_user.expects(:access?).with(:exercise).returns(true)
    assert ExercismWeb::Presenters::Profile.new(@user, current_user).access?(:exercise)
  end
end
