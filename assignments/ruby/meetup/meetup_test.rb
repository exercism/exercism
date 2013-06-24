require 'minitest/autorun'
require 'minitest/pride'
require 'date'
require_relative 'meetup'

class MeetupTest < MiniTest::Unit::TestCase

  def test_monteenth_of_may_2013
    assert_equal Date.new(2013, 5, 13), Meetup.new(5, 2013).monteenth
  end

  def test_monteenth_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 19), Meetup.new(8, 2013).monteenth
  end

  def test_monteenth_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 16), Meetup.new(9, 2013).monteenth
  end

  def test_tuesteenth_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 19), Meetup.new(3, 2013).tuesteenth
  end

  def test_tuesteenth_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 16), Meetup.new(4, 2013).tuesteenth
  end

  def test_tuesteenth_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 13), Meetup.new(8, 2013).tuesteenth
  end

  def test_wednesteenth_of_january_2013
    skip
    assert_equal Date.new(2013, 1, 16), Meetup.new(1, 2013).wednesteenth
  end

  def test_wednesteenth_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 13), Meetup.new(2, 2013).wednesteenth
  end

  def test_wednesteenth_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 19), Meetup.new(6, 2013).wednesteenth
  end

  def test_thursteenth_of_may_2013
    skip
    assert_equal Date.new(2013, 5, 16), Meetup.new(5, 2013).thursteenth
  end

  def test_thursteenth_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 13), Meetup.new(6, 2013).thursteenth
  end

  def test_thursteenth_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 19), Meetup.new(9, 2013).thursteenth
  end

  def test_friteenth_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 19), Meetup.new(4, 2013).friteenth
  end

  def test_friteenth_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 16), Meetup.new(8, 2013).friteenth
  end

  def test_friteenth_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 13), Meetup.new(9, 2013).friteenth
  end

  def test_saturteenth_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 16), Meetup.new(2, 2013).saturteenth
  end

  def test_saturteenth_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 13), Meetup.new(4, 2013).saturteenth
  end

  def test_saturteenth_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 19), Meetup.new(10, 2013).saturteenth
  end

  def test_sunteenth_of_map_2013
    skip
    assert_equal Date.new(2013, 5, 19), Meetup.new(5, 2013).sunteenth
  end

  def test_sunteenth_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 16), Meetup.new(6, 2013).sunteenth
  end

  def test_sunteenth_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 13), Meetup.new(10, 2013).sunteenth
  end

  def test_first_monday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 4), Meetup.new(3, 2013).first_monday
  end

  def test_first_monday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 1), Meetup.new(4, 2013).first_monday
  end

  def test_first_tuesday_of_may_2013
    skip
    assert_equal Date.new(2013, 5, 7), Meetup.new(5, 2013).first_tuesday
  end

  def test_first_tuesday_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 4), Meetup.new(6, 2013).first_tuesday
  end

  def test_first_wednesday_of_july_2013
    skip
    assert_equal Date.new(2013, 7, 3), Meetup.new(7, 2013).first_wednesday
  end

  def test_first_wednesday_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 7), Meetup.new(8, 2013).first_wednesday
  end

  def test_first_thursday_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 5), Meetup.new(9, 2013).first_thursday
  end

  def test_first_thursday_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 3), Meetup.new(10, 2013).first_thursday
  end

  def test_first_friday_of_november_2013
    skip
    assert_equal Date.new(2013, 11, 1), Meetup.new(11, 2013).first_friday
  end

  def test_first_friday_of_december_2013
    skip
    assert_equal Date.new(2013, 12, 6), Meetup.new(12, 2013).first_friday
  end

  def test_first_saturday_of_january_2013
    skip
    assert_equal Date.new(2013, 1, 5), Meetup.new(1, 2013).first_saturday
  end

  def test_first_saturday_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 2), Meetup.new(2, 2013).first_saturday
  end

  def test_first_sunday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 3), Meetup.new(3, 2013).first_sunday
  end

  def test_first_sunday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 7), Meetup.new(4, 2013).first_sunday
  end

  def test_second_monday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 11), Meetup.new(3, 2013).second_monday
  end

  def test_second_monday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 8), Meetup.new(4, 2013).second_monday
  end

  def test_second_tuesday_of_may_2013
    skip
    assert_equal Date.new(2013, 5, 14), Meetup.new(5, 2013).second_tuesday
  end

  def test_second_tuesday_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 11), Meetup.new(6, 2013).second_tuesday
  end

  def test_second_wednesday_of_july_2013
    skip
    assert_equal Date.new(2013, 7, 10), Meetup.new(7, 2013).second_wednesday
  end

  def test_second_wednesday_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 14), Meetup.new(8, 2013).second_wednesday
  end

  def test_second_thursday_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 12), Meetup.new(9, 2013).second_thursday
  end

  def test_second_thursday_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 10), Meetup.new(10, 2013).second_thursday
  end

  def test_second_friday_of_november_2013
    skip
    assert_equal Date.new(2013, 11, 8), Meetup.new(11, 2013).second_friday
  end

  def test_second_friday_of_december_2013
    skip
    assert_equal Date.new(2013, 12, 13), Meetup.new(12, 2013).second_friday
  end

  def test_second_saturday_of_january_2013
    skip
    assert_equal Date.new(2013, 1, 12), Meetup.new(1, 2013).second_saturday
  end

  def test_second_saturday_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 9), Meetup.new(2, 2013).second_saturday
  end

  def test_second_sunday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 10), Meetup.new(3, 2013).second_sunday
  end

  def test_second_sunday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 14), Meetup.new(4, 2013).second_sunday
  end

  def test_third_monday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 18), Meetup.new(3, 2013).third_monday
  end

  def test_third_monday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 15), Meetup.new(4, 2013).third_monday
  end

  def test_third_tuesday_of_may_2013
    skip
    assert_equal Date.new(2013, 5, 21), Meetup.new(5, 2013).third_tuesday
  end

  def test_third_tuesday_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 18), Meetup.new(6, 2013).third_tuesday
  end

  def test_third_wednesday_of_july_2013
    skip
    assert_equal Date.new(2013, 7, 17), Meetup.new(7, 2013).third_wednesday
  end

  def test_third_wednesday_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 21), Meetup.new(8, 2013).third_wednesday
  end

  def test_third_thursday_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 19), Meetup.new(9, 2013).third_thursday
  end

  def test_third_thursday_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 17), Meetup.new(10, 2013).third_thursday
  end

  def test_third_friday_of_november_2013
    skip
    assert_equal Date.new(2013, 11, 15), Meetup.new(11, 2013).third_friday
  end

  def test_third_friday_of_december_2013
    skip
    assert_equal Date.new(2013, 12, 20), Meetup.new(12, 2013).third_friday
  end

  def test_third_saturday_of_january_2013
    skip
    assert_equal Date.new(2013, 1, 19), Meetup.new(1, 2013).third_saturday
  end

  def test_third_saturday_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 16), Meetup.new(2, 2013).third_saturday
  end

  def test_third_sunday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 17), Meetup.new(3, 2013).third_sunday
  end

  def test_third_sunday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 21), Meetup.new(4, 2013).third_sunday
  end

  def test_fourth_monday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 25), Meetup.new(3, 2013).fourth_monday
  end

  def test_fourth_monday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 22), Meetup.new(4, 2013).fourth_monday
  end

  def test_fourth_tuesday_of_may_2013
    skip
    assert_equal Date.new(2013, 5, 28), Meetup.new(5, 2013).fourth_tuesday
  end

  def test_fourth_tuesday_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 25), Meetup.new(6, 2013).fourth_tuesday
  end

  def test_fourth_wednesday_of_july_2013
    skip
    assert_equal Date.new(2013, 7, 24), Meetup.new(7, 2013).fourth_wednesday
  end

  def test_fourth_wednesday_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 28), Meetup.new(8, 2013).fourth_wednesday
  end

  def test_fourth_thursday_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 26), Meetup.new(9, 2013).fourth_thursday
  end

  def test_fourth_thursday_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 24), Meetup.new(10, 2013).fourth_thursday
  end

  def test_fourth_friday_of_november_2013
    skip
    assert_equal Date.new(2013, 11, 22), Meetup.new(11, 2013).fourth_friday
  end

  def test_fourth_friday_of_december_2013
    skip
    assert_equal Date.new(2013, 12, 27), Meetup.new(12, 2013).fourth_friday
  end

  def test_fourth_saturday_of_january_2013
    skip
    assert_equal Date.new(2013, 1, 26), Meetup.new(1, 2013).fourth_saturday
  end

  def test_fourth_saturday_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 23), Meetup.new(2, 2013).fourth_saturday
  end

  def test_fourth_sunday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 24), Meetup.new(3, 2013).fourth_sunday
  end

  def test_fourth_sunday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 28), Meetup.new(4, 2013).fourth_sunday
  end

  def test_last_monday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 25), Meetup.new(3, 2013).last_monday
  end

  def test_last_monday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 29), Meetup.new(4, 2013).last_monday
  end

  def test_last_tuesday_of_may_2013
    skip
    assert_equal Date.new(2013, 5, 28), Meetup.new(5, 2013).last_tuesday
  end

  def test_last_tuesday_of_june_2013
    skip
    assert_equal Date.new(2013, 6, 25), Meetup.new(6, 2013).last_tuesday
  end

  def test_last_wednesday_of_july_2013
    skip
    assert_equal Date.new(2013, 7, 31), Meetup.new(7, 2013).last_wednesday
  end

  def test_last_wednesday_of_august_2013
    skip
    assert_equal Date.new(2013, 8, 28), Meetup.new(8, 2013).last_wednesday
  end

  def test_last_thursday_of_september_2013
    skip
    assert_equal Date.new(2013, 9, 26), Meetup.new(9, 2013).last_thursday
  end

  def test_last_thursday_of_october_2013
    skip
    assert_equal Date.new(2013, 10, 31), Meetup.new(10, 2013).last_thursday
  end

  def test_last_friday_of_november_2013
    skip
    assert_equal Date.new(2013, 11, 29), Meetup.new(11, 2013).last_friday
  end

  def test_last_friday_of_december_2013
    skip
    assert_equal Date.new(2013, 12, 27), Meetup.new(12, 2013).last_friday
  end

  def test_last_saturday_of_january_2013
    skip
    assert_equal Date.new(2013, 1, 26), Meetup.new(1, 2013).last_saturday
  end

  def test_last_saturday_of_february_2013
    skip
    assert_equal Date.new(2013, 2, 23), Meetup.new(2, 2013).last_saturday
  end

  def test_last_sunday_of_march_2013
    skip
    assert_equal Date.new(2013, 3, 31), Meetup.new(3, 2013).last_sunday
  end

  def test_last_sunday_of_april_2013
    skip
    assert_equal Date.new(2013, 4, 28), Meetup.new(4, 2013).last_sunday
  end

end

