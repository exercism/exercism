defmodule Anagram do
  def match(base, candidates) do
    b = canonical base
    Enum.filter candidates, fn(c) -> b == canonical c end
  end

  defp canonical(string), do: :lists.sort String.codepoints string
end
