defmodule Words do
  def count(sentence) do
    sentence
      |> String.downcase
      |> to_words
      |> summarize
  end

  defp to_words(sentence), do: List.flatten Regex.scan(%r/[\p{L}\p{N}-]+/, sentence)

  defp summarize(words) do
    Enum.reduce words, HashDict.new, &add_count/2
  end

  defp add_count(word, counts) do
    HashDict.update counts, word, 1, &(&1 + 1)
  end
end
