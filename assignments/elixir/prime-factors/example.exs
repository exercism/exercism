defmodule PrimeFactors do
  def for(n) when n < 2, do: []
  def for(number) do
    case least_divisor(number) do
      nil    -> [number]
      factor -> [factor, for round(number/factor)]
    end |> List.flatten
  end

  defp least_divisor(number) do
    number
      |> factor_range
      |> Stream.filter(&(rem(number, &1) == 0))
      |> Enum.first
  end

  defp factor_range(number), do: (2..round(number/2))
end
