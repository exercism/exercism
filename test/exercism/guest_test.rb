require_relative '../test_helper'
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

  private

  def guest
    Guest.new
  end

end
