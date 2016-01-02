require_relative '../integration_helper'

class DailyCountTest < Minitest::Test
  include DBCleaner

  def test_today_scope_with_user_records
    fred = User.create(username: 'fred')
    five = DailyCount.create(user: fred, total: 2, day: Date.today)
    assert_equal(five, DailyCount.today)
  end
end
