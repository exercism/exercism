defmodule Frequency do
  @doc """
  Count word frequency in parallel.

  Returns a dict of characters to frequencies.
  """
  def frequency(texts, workers) do
    groups = Enum.map(0..(workers-1), &stripe(&1, texts, workers)) 
    Enum.map(groups, &Frequency.count_texts/1)
    #:rpc.pmap({Frequency, :count_texts}, [], groups)
    |> merge_freqs()
  end

  defp stripe(n, texts, workers) do
    Enum.drop(texts, n) |> Enum.take_every(workers)
  end

  # Needs to be public because of how it's invoked by `:rpc.pmap/4`.
  @doc false
  def count_texts(texts) do
    Enum.map(texts, &count_text/1)
    |> merge_freqs()
  end

  defp count_text(string) do
    # At the time of writing Elixir doesn't yet have a way to determine if a
    # character is a letter. So use a workaround with Regex.
    String.replace(string, %r/\P{L}+/u, "") # \P{L} = anything but a letter
    |> String.downcase()
    |> String.graphemes()
    |> Enum.reduce(HashDict.new(), fn c, acc -> Dict.update(acc, c, 1, &(&1+1)) end)
  end

  defp merge_freqs(dicts) do
    Enum.reduce(dicts, HashDict.new(), fn d, acc ->
      Dict.merge(acc, d, fn _, a, b -> a+b end)
    end)
  end
end
