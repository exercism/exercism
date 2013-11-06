defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """
  
  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, :last) do
    start_day = :calendar.last_day_of_the_month(year, month) - 6
    meetup_nth(year, month, start_day, weekday)
  end
  def meetup(year, month, weekday, schedule) do
    meetup_nth(year, month, schedule_start(schedule), weekday)
  end

  defp meetup_nth(year, month, start_day, weekday) do
    w = weekday_num(weekday)
    case w - :calendar.day_of_the_week(year, month, start_day) do
       n when n < 0 -> {year, month, start_day + n + 7}
       n            -> {year, month, start_day + n}
    end
  end

  # Aliases for the day of week numbers from Erlang.
  #
  # Case matching is used because that's very fast in Elixir/Erlang.
  defp weekday_num(:monday),    do: 1
  defp weekday_num(:tuesday),   do: 2
  defp weekday_num(:wednesday), do: 3
  defp weekday_num(:thursday),  do: 4
  defp weekday_num(:friday),    do: 5
  defp weekday_num(:saturday),  do: 6
  defp weekday_num(:sunday),    do: 7

  defp schedule_start(:first),  do: 1
  defp schedule_start(:second), do: 8 
  defp schedule_start(:third),  do: 15 
  defp schedule_start(:fourth), do: 22 
  defp schedule_start(:teenth), do: 13
end
