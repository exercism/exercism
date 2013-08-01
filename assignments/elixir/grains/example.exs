defmodule Grains do
  def square(number), do: round :math.pow(2, (number - 1))
  def total, do: Enum.reduce (1..64), 0, fn(n, acc) -> acc + square(n) end
end
