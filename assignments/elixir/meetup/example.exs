defmodule Meetup do
  def monteenth(month, year),        do: offset_date(year, month, 13, 1)
  def tuesteenth(month, year),       do: offset_date(year, month, 13, 2)
  def wednesteenth(month, year),     do: offset_date(year, month, 13, 3)
  def thursteenth(month, year),      do: offset_date(year, month, 13, 4)
  def friteenth(month, year),        do: offset_date(year, month, 13, 5)
  def saturteenth(month, year),      do: offset_date(year, month, 13, 6)
  def sunteenth(month, year),        do: offset_date(year, month, 13, 7)

  def first_monday(month, year),     do: offset_date(year, month, 1, 1)
  def first_tuesday(month, year),    do: offset_date(year, month, 1, 2)
  def first_wednesday(month, year),  do: offset_date(year, month, 1, 3)
  def first_thursday(month, year),   do: offset_date(year, month, 1, 4)
  def first_friday(month, year),     do: offset_date(year, month, 1, 5)
  def first_saturday(month, year),   do: offset_date(year, month, 1, 6)
  def first_sunday(month, year),     do: offset_date(year, month, 1, 7)

  def second_monday(month, year),    do: offset_date(year, month, 8, 1)
  def second_tuesday(month, year),   do: offset_date(year, month, 8, 2)
  def second_wednesday(month, year), do: offset_date(year, month, 8, 3)
  def second_thursday(month, year),  do: offset_date(year, month, 8, 4)
  def second_friday(month, year),    do: offset_date(year, month, 8, 5)
  def second_saturday(month, year),  do: offset_date(year, month, 8, 6)
  def second_sunday(month, year),    do: offset_date(year, month, 8, 7)

  def third_monday(month, year),     do: offset_date(year, month, 15, 1)
  def third_tuesday(month, year),    do: offset_date(year, month, 15, 2)
  def third_wednesday(month, year),  do: offset_date(year, month, 15, 3)
  def third_thursday(month, year),   do: offset_date(year, month, 15, 4)
  def third_friday(month, year),     do: offset_date(year, month, 15, 5)
  def third_saturday(month, year),   do: offset_date(year, month, 15, 6)
  def third_sunday(month, year),     do: offset_date(year, month, 15, 7)

  def fourth_monday(month, year),    do: offset_date(year, month, 22, 1)
  def fourth_tuesday(month, year),   do: offset_date(year, month, 22, 2)
  def fourth_wednesday(month, year), do: offset_date(year, month, 22, 3)
  def fourth_thursday(month, year),  do: offset_date(year, month, 22, 4)
  def fourth_friday(month, year),    do: offset_date(year, month, 22, 5)
  def fourth_saturday(month, year),  do: offset_date(year, month, 22, 6)
  def fourth_sunday(month, year),    do: offset_date(year, month, 22, 7)

  def last_monday(month, year),      do: offset_date(year, month, -1, -1)
  def last_tuesday(month, year),     do: offset_date(year, month, -1, -2)
  def last_wednesday(month, year),   do: offset_date(year, month, -1, -3)
  def last_thursday(month, year),    do: offset_date(year, month, -1, -4)
  def last_friday(month, year),      do: offset_date(year, month, -1, -5)
  def last_saturday(month, year),    do: offset_date(year, month, -1, -6)
  def last_sunday(month, year),      do: offset_date(year, month, -1, -7)

  def offset_date(year, month, day, day_offset) do
    starting_point = starting_point(year, month, day)
    {year, month, day_of_month(year, month, day) + days_to_move(starting_point, day_offset)}
  end

  def starting_point(year, month, -1),  do: :calendar.day_of_the_week(year, month, day_of_month(year, month, -1))
  def starting_point(year, month, day), do: :calendar.day_of_the_week(year, month, day)

  def day_of_month( year,  month, -1),  do: :calendar.last_day_of_the_month(year, month)
  def day_of_month(_year, _month, day), do: day

  def days_to_move(week_day, offset) when offset < 0, do: -1 * modulo(week_day + offset, 7)
  def days_to_move(week_day, offset), do: modulo(-1 * (week_day - offset), 7)

  def modulo(number, dividend) when number > 0, do: rem(number, dividend)
  def modulo(number, dividend) do
    m = rem(number, dividend)
    m + if m < 0, do: dividend, else: 0
  end
end
