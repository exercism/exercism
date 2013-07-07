defmodule Year do
  def leap_year?(year) do
    div4?(year) && (div100?(year) == div400?(year))
  end

  defp divides?(dividend, divisor), do: rem(dividend, divisor) == 0
  defp div4?(dividend),   do: divides?(dividend, 4)
  defp div100?(dividend), do: divides?(dividend, 100)
  defp div400?(dividend), do: divides?(dividend, 400)
end
