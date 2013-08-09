require './test/test_helper'

require 'exercism/guest'

class GuestTest < Minitest::Test

  def test_guest_is_guest
    assert guest.guest?
  end

  def test_guest_is_not_any_other
    refute guest.is?(nil)
    refute guest.is?(guest)
  end

  def test_guest_is_not_new
    refute guest.new?
  end

  def test_guest_is_not_nitpicker
    refute guest.nitpicker?
  end

  def test_guest_is_not_admin
    refute guest.admin?
  end

  def test_guest_may_not_nitpick?
    refute guest.may_nitpick?(nil)
  end

  def test_guest_is_not_locksmith
    refute guest.locksmith?
  end

  def test_guest_does_not_unlock
    refute guest.unlocks?(nil)
  end

  private

  def guest
    Guest.new
  end

end
