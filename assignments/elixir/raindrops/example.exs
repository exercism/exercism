defmodule Raindrops do
  def convert(number), do: output { [sound(number,3), sound(number,5), sound(number,7)], number }

  defp sound(n, 3) when rem(n, 3) == 0, do: "Pling"
  defp sound(n, 5) when rem(n, 5) == 0, do: "Plang"
  defp sound(n, 7) when rem(n, 7) == 0, do: "Plong"
  defp sound(_, _), do: ""

  defp output({["", "", ""], number}), do: "#{number}"
  defp output({sounds, _}), do: Enum.join sounds
end
