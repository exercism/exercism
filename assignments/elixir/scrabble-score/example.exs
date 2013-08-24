defmodule Scrabble do
  def score(word) do
    word |> letters |> summarize
  end

  defp letters(word), do: word |> String.strip |> String.downcase |> String.codepoints

  defp summarize(letters), do: Enum.reduce(letters, 0, fn(letter, acc) -> acc + letter_score(letter) end)

  @letter_scores [
    { "aeilnorstu",  1 },
    { "dg",          2 },
    { "bcmp",        3 },
    { "fhvwy",       4 },
    { "k",           5 },
    { "jx",          8 },
    { "qz",         10 }
  ]

  defp letter_score(letter) do
    Enum.find_value @letter_scores, 0, fn({letters, score}) ->
      String.contains?(letters, letter) && score
    end
  end
end
