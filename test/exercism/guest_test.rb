require_relative '../test_helper'
require 'exercism/guest'

class GuestTest < Minitest::Test

  def test_guest_is_guest
    assert Guest.new.guest?
  end

end
