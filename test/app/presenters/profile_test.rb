require_relative '../../test_helper'
require 'app/presenters/profile.rb'
require 'mocha/setup'

class ProfileTest < Minitest::Test

  def setup
    super
    user1.stubs(:is?).with(user1.username).returns(true)
    user1.stubs(:is?).with(user2.username).returns(false)
    user2.stubs(:is?).with(user2.username).returns(true)
    user2.stubs(:is?).with(user1.username).returns(false)
  end

  def user1
    @user1 ||= stub(username: 'Lucy')
  end

  def user2
    @user2 ||= stub(username: 'Trevor')
  end

  def profile
    Profile.new(user1, user2)
  end

  def narcissistic_profile
    Profile.new(user1)
  end

  def test_no_current_submissions_message
    assert_equal "Lucy has not submitted any exercises lately.", profile.no_current_submissions_message
  end

  def test_narcissistic_no_current_submissions_message
    assert_equal "You have not submitted any exercises lately.", narcissistic_profile.no_current_submissions_message
  end

  def test_no_completed_submissions_message
    assert_equal "Lucy has not completed any exercises yet.", profile.no_completed_submissions_message
  end

  def test_narcissistic_no_completed_submissions_message
    assert_equal "You have not completed any exercises yet.", narcissistic_profile.no_completed_submissions_message
  end
end
