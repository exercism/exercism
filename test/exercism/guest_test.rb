require_relative '../test_helper'
require_relative '../active_record_helper'
require 'exercism/guest'

class GuestTest < Minitest::Test
  def test_guest?
    subject = Guest.new
    assert subject.guest?
  end

  def test_id
    subject = Guest.new
    assert_nil subject.id
  end

  def test_username
    subject = Guest.new
    assert_equal 'guest', subject.username
  end

  def test_show_dailies?
    subject = Guest.new
    refute subject.show_dailies?
  end

  def test_onboarded?
    subject = Guest.new
    refute subject.onboarded?
  end

  def test_owns?
    subject = Guest.new
    refute subject.owns?('anything')
  end

  def test_access?
    subject = Guest.new
    refute subject.access?('anything')
  end

  def test_fetched?
    subject = Guest.new
    refute subject.fetched?
  end

  def test_exercises
    subject = Guest.new
    expected = UserExercise.where('1=2')
    assert_equal expected, subject.exercises
  end
end
