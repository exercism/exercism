defmodule Roman do
  @numerals [
    [1000, "M"],
    [ 900, "CM"],
    [ 500, "D"],
    [ 400, "CD"],
    [ 100, "C"],
    [  90, "XC"],
    [  50, "L"],
    [  40, "XL"],
    [  10, "X"],
    [   9, "IX"],
    [   5, "V"],
    [   4, "IV"],
    [   1, "I"]
  ]

  def numerals(0), do: ""
  def numerals(number) do
    [part, letter] = largest_factor(number)
    letter <> numerals(number - part)
  end

  defp largest_factor(number) do
    Enum.first Enum.filter(@numerals, fn([p, _]) -> p <= number end)
  end
end
