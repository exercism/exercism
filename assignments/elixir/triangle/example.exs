defmodule Triangle do
  def kind(a, b, c), do: kind Enum.sort [a, b, c]

  defp kind([a, _, _]) when a <= 0, do: { :error, "all side lengths must be positive" }
  defp kind([a, b, c]) when a + b <= c, do: { :error, "side lengths violate triangle inequality" }
  defp kind([x, x, x]), do: { :ok, :equilateral }
  defp kind([x, x, _]), do: { :ok, :isosceles }
  defp kind([_, x, x]), do: { :ok, :isosceles }
  defp kind([_, _, _]), do: { :ok, :scalene }
end
