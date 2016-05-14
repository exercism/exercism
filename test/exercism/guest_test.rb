require_relative '../test_helper'
require 'exercism/guest'

class GuestTest < Minitest::Test
  def test_guest_is_guest
    assert Guest.new.guest?
  end

  def test_guest_submissions_per_language_is_nil
    assert Guest.new.submissions_per_language == nil
  end
end
