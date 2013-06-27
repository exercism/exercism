defmodule Words do
  import String, only: [ split: 2, downcase: 1 ]
  import Regex,  only: [ replace: 3 ]

  def count(string) do
    string
      |> downcase
      |> sanitize
      |> to_list
      |> summarize
  end

  defp sanitize(string), do: Regex.replace %r{[^a-z0-9 ]}, string, ""
  defp to_list(string),  do: split string, %r{\s+}
  defp summarize(substrings)  do
    List.foldl substrings, HashDict.new, fn(s, acc) ->
      HashDict.merge acc, [{s, 1}], fn(_k, v1, v2) -> (v1 || 0) + v2 end
    end
  end
end
