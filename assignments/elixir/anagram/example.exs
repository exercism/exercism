defmodule Anagram do
  @doc """
  Returns those words that are anagrams of the `w` word.

  Comparison is case insensitive.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(target, words) do
    lc_target = String.downcase(target)
    sorted_target = sort(lc_target)
    Enum.filter(words, fn word ->
      lc_word = String.downcase(word)
      # `and` is shortcutting
      lc_word != lc_target and sort(lc_word) == sorted_target
    end)
  end

  defp sort(s) do
    # :lists.sort is specialized on lists, which saves the overhead of the
    # reduce based Enum functions.
    String.graphemes(s) |> :lists.sort()
  end
end
