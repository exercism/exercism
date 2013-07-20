Code.load_file("meetup.exs")
ExUnit.start

defmodule MeetupTest do
  use ExUnit.Case, async: true
  doctest Meetup

  test "monteenth of may 2013" do
    assert {2013, 5, 13} == Meetup.monteenth(5, 2013)
  end

  test "monteenth of august 2013" do
    # assert {2013, 8, 19} == Meetup.monteenth(8, 2013)
  end

  test "monteenth of september 2013" do
    # assert {2013, 9, 16} == Meetup.monteenth(9, 2013)
  end

  test "tuesteenth of march 2013" do
    # assert {2013, 3, 19} == Meetup.tuesteenth(3, 2013)
  end

  test "tuesteenth of april 2013" do
    # assert {2013, 4, 16} == Meetup.tuesteenth(4, 2013)
  end

  test "tuesteenth of august 2013" do
    # assert {2013, 8, 13} == Meetup.tuesteenth(8, 2013)
  end

  test "wednesteenth of january 2013" do
    # assert {2013, 1, 16} == Meetup.wednesteenth(1, 2013)
  end

  test "wednesteenth of february 2013" do
    # assert {2013, 2, 13} == Meetup.wednesteenth(2, 2013)
  end

  test "wednesteenth of june 2013" do
    # assert {2013, 6, 19} == Meetup.wednesteenth(6, 2013)
  end

  test "thursteenth of may 2013" do
    # assert {2013, 5, 16} == Meetup.thursteenth(5, 2013)
  end

  test "thursteenth of june 2013" do
    # assert {2013, 6, 13} == Meetup.thursteenth(6, 2013)
  end

  test "thursteenth of september 2013" do
    # assert {2013, 9, 19} == Meetup.thursteenth(9, 2013)
  end

  test "friteenth of april 2013" do
    # assert {2013, 4, 19} == Meetup.friteenth(4, 2013)
  end

  test "friteenth of august 2013" do
    # assert {2013, 8, 16} == Meetup.friteenth(8, 2013)
  end

  test "friteenth of september 2013" do
    # assert {2013, 9, 13} == Meetup.friteenth(9, 2013)
  end

  test "saturteenth of february 2013" do
    # assert {2013, 2, 16} == Meetup.saturteenth(2, 2013)
  end

  test "saturteenth of april 2013" do
    # assert {2013, 4, 13} == Meetup.saturteenth(4, 2013)
  end

  test "saturteenth of october 2013" do
    # assert {2013, 10, 19} == Meetup.saturteenth(10, 2013)
  end

  test "sunteenth of map 2013" do
    # assert {2013, 5, 19} == Meetup.sunteenth(5, 2013)
  end

  test "sunteenth of june 2013" do
    # assert {2013, 6, 16} == Meetup.sunteenth(6, 2013)
  end

  test "sunteenth of october 2013" do
    # assert {2013, 10, 13} == Meetup.sunteenth(10, 2013)
  end

  test "first monday of march 2013" do
    # assert {2013, 3, 4} == Meetup.first_monday(3, 2013)
  end

  test "first monday of april 2013" do
    # assert {2013, 4, 1} == Meetup.first_monday(4, 2013)
  end

  test "first tuesday of may 2013" do
    # assert {2013, 5, 7} == Meetup.first_tuesday(5, 2013)
  end

  test "first tuesday of june 2013" do
    # assert {2013, 6, 4} == Meetup.first_tuesday(6, 2013)
  end

  test "first wednesday of july 2013" do
    # assert {2013, 7, 3} == Meetup.first_wednesday(7, 2013)
  end

  test "first wednesday of august 2013" do
    # assert {2013, 8, 7} == Meetup.first_wednesday(8, 2013)
  end

  test "first thursday of september 2013" do
    # assert {2013, 9, 5} == Meetup.first_thursday(9, 2013)
  end

  test "first thursday of october 2013" do
    # assert {2013, 10, 3} == Meetup.first_thursday(10, 2013)
  end

  test "first friday of november 2013" do
    # assert {2013, 11, 1} == Meetup.first_friday(11, 2013)
  end

  test "first friday of december 2013" do
    # assert {2013, 12, 6} == Meetup.first_friday(12, 2013)
  end

  test "first saturday of january 2013" do
    # assert {2013, 1, 5} == Meetup.first_saturday(1, 2013)
  end

  test "first saturday of february 2013" do
    # assert {2013, 2, 2} == Meetup.first_saturday(2, 2013)
  end

  test "first sunday of march 2013" do
    # assert {2013, 3, 3} == Meetup.first_sunday(3, 2013)
  end

  test "first sunday of april 2013" do
    # assert {2013, 4, 7} == Meetup.first_sunday(4, 2013)
  end

  test "second monday of march 2013" do
    # assert {2013, 3, 11} == Meetup.second_monday(3, 2013)
  end

  test "second monday of april 2013" do
    # assert {2013, 4, 8} == Meetup.second_monday(4, 2013)
  end

  test "second tuesday of may 2013" do
    # assert {2013, 5, 14} == Meetup.second_tuesday(5, 2013)
  end

  test "second tuesday of june 2013" do
    # assert {2013, 6, 11} == Meetup.second_tuesday(6, 2013)
  end

  test "second wednesday of july 2013" do
    # assert {2013, 7, 10} == Meetup.second_wednesday(7, 2013)
  end

  test "second wednesday of august 2013" do
    # assert {2013, 8, 14} == Meetup.second_wednesday(8, 2013)
  end

  test "second thursday of september 2013" do
    # assert {2013, 9, 12} == Meetup.second_thursday(9, 2013)
  end

  test "second thursday of october 2013" do
    # assert {2013, 10, 10} == Meetup.second_thursday(10, 2013)
  end

  test "second friday of november 2013" do
    # assert {2013, 11, 8} == Meetup.second_friday(11, 2013)
  end

  test "second friday of december 2013" do
    # assert {2013, 12, 13} == Meetup.second_friday(12, 2013)
  end

  test "second saturday of january 2013" do
    # assert {2013, 1, 12} == Meetup.second_saturday(1, 2013)
  end

  test "second saturday of february 2013" do
    # assert {2013, 2, 9} == Meetup.second_saturday(2, 2013)
  end

  test "second sunday of march 2013" do
    # assert {2013, 3, 10} == Meetup.second_sunday(3, 2013)
  end

  test "second sunday of april 2013" do
    # assert {2013, 4, 14} == Meetup.second_sunday(4, 2013)
  end

  test "third monday of march 2013" do
    # assert {2013, 3, 18} == Meetup.third_monday(3, 2013)
  end

  test "third monday of april 2013" do
    # assert {2013, 4, 15} == Meetup.third_monday(4, 2013)
  end

  test "third tuesday of may 2013" do
    # assert {2013, 5, 21} == Meetup.third_tuesday(5, 2013)
  end

  test "third tuesday of june 2013" do
    # assert {2013, 6, 18} == Meetup.third_tuesday(6, 2013)
  end

  test "third wednesday of july 2013" do
    # assert {2013, 7, 17} == Meetup.third_wednesday(7, 2013)
  end

  test "third wednesday of august 2013" do
    # assert {2013, 8, 21} == Meetup.third_wednesday(8, 2013)
  end

  test "third thursday of september 2013" do
    # assert {2013, 9, 19} == Meetup.third_thursday(9, 2013)
  end

  test "third thursday of october 2013" do
    # assert {2013, 10, 17} == Meetup.third_thursday(10, 2013)
  end

  test "third friday of november 2013" do
    # assert {2013, 11, 15} == Meetup.third_friday(11, 2013)
  end

  test "third friday of december 2013" do
    # assert {2013, 12, 20} == Meetup.third_friday(12, 2013)
  end

  test "third saturday of january 2013" do
    # assert {2013, 1, 19} == Meetup.third_saturday(1, 2013)
  end

  test "third saturday of february 2013" do
    # assert {2013, 2, 16} == Meetup.third_saturday(2, 2013)
  end

  test "third sunday of march 2013" do
    # assert {2013, 3, 17} == Meetup.third_sunday(3, 2013)
  end

  test "third sunday of april 2013" do
    # assert {2013, 4, 21} == Meetup.third_sunday(4, 2013)
  end

  test "fourth monday of march 2013" do
    # assert {2013, 3, 25} == Meetup.fourth_monday(3, 2013)
  end

  test "fourth monday of april 2013" do
    # assert {2013, 4, 22} == Meetup.fourth_monday(4, 2013)
  end

  test "fourth tuesday of may 2013" do
    # assert {2013, 5, 28} == Meetup.fourth_tuesday(5, 2013)
  end

  test "fourth tuesday of june 2013" do
    # assert {2013, 6, 25} == Meetup.fourth_tuesday(6, 2013)
  end

  test "fourth wednesday of july 2013" do
    # assert {2013, 7, 24} == Meetup.fourth_wednesday(7, 2013)
  end

  test "fourth wednesday of august 2013" do
    # assert {2013, 8, 28} == Meetup.fourth_wednesday(8, 2013)
  end

  test "fourth thursday of september 2013" do
    # assert {2013, 9, 26} == Meetup.fourth_thursday(9, 2013)
  end

  test "fourth thursday of october 2013" do
    # assert {2013, 10, 24} == Meetup.fourth_thursday(10, 2013)
  end

  test "fourth friday of november 2013" do
    # assert {2013, 11, 22} == Meetup.fourth_friday(11, 2013)
  end

  test "fourth friday of december 2013" do
    # assert {2013, 12, 27} == Meetup.fourth_friday(12, 2013)
  end

  test "fourth saturday of january 2013" do
    # assert {2013, 1, 26} == Meetup.fourth_saturday(1, 2013)
  end

  test "fourth saturday of february 2013" do
    # assert {2013, 2, 23} == Meetup.fourth_saturday(2, 2013)
  end

  test "fourth sunday of march 2013" do
    # assert {2013, 3, 24} == Meetup.fourth_sunday(3, 2013)
  end

  test "fourth sunday of april 2013" do
    # assert {2013, 4, 28} == Meetup.fourth_sunday(4, 2013)
  end

  test "last monday of march 2013" do
    # assert {2013, 3, 25} == Meetup.last_monday(3, 2013)
  end

  test "last monday of april 2013" do
    # assert {2013, 4, 29} == Meetup.last_monday(4, 2013)
  end

  test "last tuesday of may 2013" do
    # assert {2013, 5, 28} == Meetup.last_tuesday(5, 2013)
  end

  test "last tuesday of june 2013" do
    # assert {2013, 6, 25} == Meetup.last_tuesday(6, 2013)
  end

  test "last wednesday of july 2013" do
    # assert {2013, 7, 31} == Meetup.last_wednesday(7, 2013)
  end

  test "last wednesday of august 2013" do
    # assert {2013, 8, 28} == Meetup.last_wednesday(8, 2013)
  end

  test "last thursday of september 2013" do
    # assert {2013, 9, 26} == Meetup.last_thursday(9, 2013)
  end

  test "last thursday of october 2013" do
    # assert {2013, 10, 31} == Meetup.last_thursday(10, 2013)
  end

  test "last friday of november 2013" do
    # assert {2013, 11, 29} == Meetup.last_friday(11, 2013)
  end

  test "last friday of december 2013" do
    # assert {2013, 12, 27} == Meetup.last_friday(12, 2013)
  end

  test "last saturday of january 2013" do
    # assert {2013, 1, 26} == Meetup.last_saturday(1, 2013)
  end

  test "last saturday of february 2013" do
    # assert {2013, 2, 23} == Meetup.last_saturday(2, 2013)
  end

  test "last sunday of march 2013" do
    # assert {2013, 3, 31} == Meetup.last_sunday(3, 2013)
  end

  test "last sunday of april 2013" do
    # assert {2013, 4, 28} == Meetup.last_sunday(4, 2013)
  end
end

