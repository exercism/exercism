defmodule PrimeFactors do
  def factors_for(n) when n < 2, do: []
  def factors_for(number) do
    case least_divisor(number) do
      nil    -> [number]
      factor -> [factor, factors_for(round(number/factor))]
    end |> List.flatten
  end

  defp least_divisor(number) do
    number
      |> factor_range
      |> Stream.filter(&(rem(number, &1) == 0))
      |> Enum.at(0)
  end

  defp factor_range(number), do: (2..round(number/2))
end
