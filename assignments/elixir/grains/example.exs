defmodule Grains do
  use Bitwise, only_operators: true
  def square(number), do: 1 <<< (number - 1)
  def total, do: Enum.reduce(1..64, 0, fn(n, acc) -> acc + square(n) end)
end
