require_relative '../integration_helper'

class FiveADayCountTest < Minitest::Test
  include DBCleaner

  def test_today_scope_with_user_records
    fred = User.create(username: 'fred')
    five = FiveADayCount.create(user: fred, total: 2, day: Date.today)
    assert_equal(five, FiveADayCount.today)
  end
end
