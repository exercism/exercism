if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("meetup.exs")
end

ExUnit.start

defmodule MeetupTest do
  use ExUnit.Case, async: false
  doctest Meetup

  test "monteenth of may 2013" do
    assert {2013, 5, 13} == Meetup.meetup(2013, 5, :monday, :teenth)
  end

  test "monteenth of august 2013" do
    assert {2013, 8, 19} == Meetup.meetup(2013, 8, :monday, :teenth)
  end

  test "monteenth of september 2013" do
    assert {2013, 9, 16} == Meetup.meetup(2013, 9, :monday, :teenth)
  end

  test "tuesteenth of march 2013" do
    assert {2013, 3, 19} == Meetup.meetup(2013, 3, :tuesday, :teenth)
  end

  test "tuesteenth of april 2013" do
    assert {2013, 4, 16} == Meetup.meetup(2013, 4, :tuesday, :teenth)
  end

  test "tuesteenth of august 2013" do
    assert {2013, 8, 13} == Meetup.meetup(2013, 8, :tuesday, :teenth)
  end

  test "wednesteenth of january 2013" do
    assert {2013, 1, 16} == Meetup.meetup(2013, 1, :wednesday, :teenth)
  end

  test "wednesteenth of february 2013" do
    assert {2013, 2, 13} == Meetup.meetup(2013, 2, :wednesday, :teenth)
  end

  test "wednesteenth of june 2013" do
    assert {2013, 6, 19} == Meetup.meetup(2013, 6, :wednesday, :teenth)
  end

  test "thursteenth of may 2013" do
    assert {2013, 5, 16} == Meetup.meetup(2013, 5, :thursday, :teenth)
  end

  test "thursteenth of june 2013" do
    assert {2013, 6, 13} == Meetup.meetup(2013, 6, :thursday, :teenth)
  end

  test "thursteenth of september 2013" do
    assert {2013, 9, 19} == Meetup.meetup(2013, 9, :thursday, :teenth)
  end

  test "friteenth of april 2013" do
    assert {2013, 4, 19} == Meetup.meetup(2013, 4, :friday, :teenth)
  end

  test "friteenth of august 2013" do
    assert {2013, 8, 16} == Meetup.meetup(2013, 8, :friday, :teenth)
  end

  test "friteenth of september 2013" do
    assert {2013, 9, 13} == Meetup.meetup(2013, 9, :friday, :teenth)
  end

  test "saturteenth of february 2013" do
    assert {2013, 2, 16} == Meetup.meetup(2013, 2, :saturday, :teenth)
  end

  test "saturteenth of april 2013" do
    assert {2013, 4, 13} == Meetup.meetup(2013, 4, :saturday, :teenth)
  end

  test "saturteenth of october 2013" do
    assert {2013, 10, 19} == Meetup.meetup(2013, 10, :saturday, :teenth)
  end

  test "sunteenth of map 2013" do
    assert {2013, 5, 19} == Meetup.meetup(2013, 5, :sunday, :teenth)
  end

  test "sunteenth of june 2013" do
    assert {2013, 6, 16} == Meetup.meetup(2013, 6, :sunday, :teenth)
  end

  test "sunteenth of october 2013" do
    assert {2013, 10, 13} == Meetup.meetup(2013, 10, :sunday, :teenth)
  end

  test "first monday of march 2013" do
    assert {2013, 3, 4} == Meetup.meetup(2013, 3, :monday, :first)
  end

  test "first monday of april 2013" do
    assert {2013, 4, 1} == Meetup.meetup(2013, 4, :monday, :first)
  end

  test "first tuesday of may 2013" do
    assert {2013, 5, 7} == Meetup.meetup(2013, 5, :tuesday, :first)
  end

  test "first tuesday of june 2013" do
    assert {2013, 6, 4} == Meetup.meetup(2013, 6, :tuesday, :first)
  end

  test "first wednesday of july 2013" do
    assert {2013, 7, 3} == Meetup.meetup(2013, 7, :wednesday, :first)
  end

  test "first wednesday of august 2013" do
    assert {2013, 8, 7} == Meetup.meetup(2013, 8, :wednesday, :first)
  end

  test "first thursday of september 2013" do
    assert {2013, 9, 5} == Meetup.meetup(2013, 9, :thursday, :first)
  end

  test "first thursday of october 2013" do
    assert {2013, 10, 3} == Meetup.meetup(2013, 10, :thursday, :first)
  end

  test "first friday of november 2013" do
    assert {2013, 11, 1} == Meetup.meetup(2013, 11, :friday, :first)
  end

  test "first friday of december 2013" do
    assert {2013, 12, 6} == Meetup.meetup(2013, 12, :friday, :first)
  end

  test "first saturday of january 2013" do
    assert {2013, 1, 5} == Meetup.meetup(2013, 1, :saturday, :first)
  end

  test "first saturday of february 2013" do
    assert {2013, 2, 2} == Meetup.meetup(2013, 2, :saturday, :first)
  end

  test "first sunday of march 2013" do
    assert {2013, 3, 3} == Meetup.meetup(2013, 3, :sunday, :first)
  end

  test "first sunday of april 2013" do
    assert {2013, 4, 7} == Meetup.meetup(2013, 4, :sunday, :first)
  end

  test "second monday of march 2013" do
    assert {2013, 3, 11} == Meetup.meetup(2013, 3, :monday, :second)
  end

  test "second monday of april 2013" do
    assert {2013, 4, 8} == Meetup.meetup(2013, 4, :monday, :second)
  end

  test "second tuesday of may 2013" do
    assert {2013, 5, 14} == Meetup.meetup(2013, 5, :tuesday, :second)
  end

  test "second tuesday of june 2013" do
    assert {2013, 6, 11} == Meetup.meetup(2013, 6, :tuesday, :second)
  end

  test "second wednesday of july 2013" do
    assert {2013, 7, 10} == Meetup.meetup(2013, 7, :wednesday, :second)
  end

  test "second wednesday of august 2013" do
    assert {2013, 8, 14} == Meetup.meetup(2013, 8, :wednesday, :second)
  end

  test "second thursday of september 2013" do
    assert {2013, 9, 12} == Meetup.meetup(2013, 9, :thursday, :second)
  end

  test "second thursday of october 2013" do
    assert {2013, 10, 10} == Meetup.meetup(2013, 10, :thursday, :second)
  end

  test "second friday of november 2013" do
    assert {2013, 11, 8} == Meetup.meetup(2013, 11, :friday, :second)
  end

  test "second friday of december 2013" do
    assert {2013, 12, 13} == Meetup.meetup(2013, 12, :friday, :second)
  end

  test "second saturday of january 2013" do
    assert {2013, 1, 12} == Meetup.meetup(2013, 1, :saturday, :second)
  end

  test "second saturday of february 2013" do
    assert {2013, 2, 9} == Meetup.meetup(2013, 2, :saturday, :second)
  end

  test "second sunday of march 2013" do
    assert {2013, 3, 10} == Meetup.meetup(2013, 3, :sunday, :second)
  end

  test "second sunday of april 2013" do
    assert {2013, 4, 14} == Meetup.meetup(2013, 4, :sunday, :second)
  end

  test "third monday of march 2013" do
    assert {2013, 3, 18} == Meetup.meetup(2013, 3, :monday, :third)
  end

  test "third monday of april 2013" do
    assert {2013, 4, 15} == Meetup.meetup(2013, 4, :monday, :third)
  end

  test "third tuesday of may 2013" do
    assert {2013, 5, 21} == Meetup.meetup(2013, 5, :tuesday, :third)
  end

  test "third tuesday of june 2013" do
    assert {2013, 6, 18} == Meetup.meetup(2013, 6, :tuesday, :third)
  end

  test "third wednesday of july 2013" do
    assert {2013, 7, 17} == Meetup.meetup(2013, 7, :wednesday, :third)
  end

  test "third wednesday of august 2013" do
    assert {2013, 8, 21} == Meetup.meetup(2013, 8, :wednesday, :third)
  end

  test "third thursday of september 2013" do
    assert {2013, 9, 19} == Meetup.meetup(2013, 9, :thursday, :third)
  end

  test "third thursday of october 2013" do
    assert {2013, 10, 17} == Meetup.meetup(2013, 10, :thursday, :third)
  end

  test "third friday of november 2013" do
    assert {2013, 11, 15} == Meetup.meetup(2013, 11, :friday, :third)
  end

  test "third friday of december 2013" do
    assert {2013, 12, 20} == Meetup.meetup(2013, 12, :friday, :third)
  end

  test "third saturday of january 2013" do
    assert {2013, 1, 19} == Meetup.meetup(2013, 1, :saturday, :third)
  end

  test "third saturday of february 2013" do
    assert {2013, 2, 16} == Meetup.meetup(2013, 2, :saturday, :third)
  end

  test "third sunday of march 2013" do
    assert {2013, 3, 17} == Meetup.meetup(2013, 3, :sunday, :third)
  end

  test "third sunday of april 2013" do
    assert {2013, 4, 21} == Meetup.meetup(2013, 4, :sunday, :third)
  end

  test "fourth monday of march 2013" do
    assert {2013, 3, 25} == Meetup.meetup(2013, 3, :monday, :fourth)
  end

  test "fourth monday of april 2013" do
    assert {2013, 4, 22} == Meetup.meetup(2013, 4, :monday, :fourth)
  end

  test "fourth tuesday of may 2013" do
    assert {2013, 5, 28} == Meetup.meetup(2013, 5, :tuesday, :fourth)
  end

  test "fourth tuesday of june 2013" do
    assert {2013, 6, 25} == Meetup.meetup(2013, 6, :tuesday, :fourth)
  end

  test "fourth wednesday of july 2013" do
    assert {2013, 7, 24} == Meetup.meetup(2013, 7, :wednesday, :fourth)
  end

  test "fourth wednesday of august 2013" do
    assert {2013, 8, 28} == Meetup.meetup(2013, 8, :wednesday, :fourth)
  end

  test "fourth thursday of september 2013" do
    assert {2013, 9, 26} == Meetup.meetup(2013, 9, :thursday, :fourth)
  end

  test "fourth thursday of october 2013" do
    assert {2013, 10, 24} == Meetup.meetup(2013, 10, :thursday, :fourth)
  end

  test "fourth friday of november 2013" do
    assert {2013, 11, 22} == Meetup.meetup(2013, 11, :friday, :fourth)
  end

  test "fourth friday of december 2013" do
    assert {2013, 12, 27} == Meetup.meetup(2013, 12, :friday, :fourth)
  end

  test "fourth saturday of january 2013" do
    assert {2013, 1, 26} == Meetup.meetup(2013, 1, :saturday, :fourth)
  end

  test "fourth saturday of february 2013" do
    assert {2013, 2, 23} == Meetup.meetup(2013, 2, :saturday, :fourth)
  end

  test "fourth sunday of march 2013" do
    assert {2013, 3, 24} == Meetup.meetup(2013, 3, :sunday, :fourth)
  end

  test "fourth sunday of april 2013" do
    assert {2013, 4, 28} == Meetup.meetup(2013, 4, :sunday, :fourth)
  end

  test "last monday of march 2013" do
    assert {2013, 3, 25} == Meetup.meetup(2013, 3, :monday, :last)
  end

  test "last monday of april 2013" do
    assert {2013, 4, 29} == Meetup.meetup(2013, 4, :monday, :last)
  end

  test "last tuesday of may 2013" do
    assert {2013, 5, 28} == Meetup.meetup(2013, 5, :tuesday, :last)
  end

  test "last tuesday of june 2013" do
    assert {2013, 6, 25} == Meetup.meetup(2013, 6, :tuesday, :last)
  end

  test "last wednesday of july 2013" do
    assert {2013, 7, 31} == Meetup.meetup(2013, 7, :wednesday, :last)
  end

  test "last wednesday of august 2013" do
    assert {2013, 8, 28} == Meetup.meetup(2013, 8, :wednesday, :last)
  end

  test "last thursday of september 2013" do
    assert {2013, 9, 26} == Meetup.meetup(2013, 9, :thursday, :last)
  end

  test "last thursday of october 2013" do
    assert {2013, 10, 31} == Meetup.meetup(2013, 10, :thursday, :last)
  end

  test "last friday of november 2013" do
    assert {2013, 11, 29} == Meetup.meetup(2013, 11, :friday, :last)
  end

  test "last friday of december 2013" do
    assert {2013, 12, 27} == Meetup.meetup(2013, 12, :friday, :last)
  end

  test "last saturday of january 2013" do
    assert {2013, 1, 26} == Meetup.meetup(2013, 1, :saturday, :last)
  end

  test "last saturday of february 2013" do
    assert {2013, 2, 23} == Meetup.meetup(2013, 2, :saturday, :last)
  end

  test "last sunday of march 2013" do
    assert {2013, 3, 31} == Meetup.meetup(2013, 3, :sunday, :last)
  end

  test "last sunday of april 2013" do
    assert {2013, 4, 28} == Meetup.meetup(2013, 4, :sunday, :last)
  end
end

