defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(HashDict.new [{"a", ["ABILITY", "AARDVARK"]}, {"b", ["BALLAST", "BEAUTY"]}])
  HashDict.new [{"ability", "a"},{"aardvark","a"},{"ballast","b"},{"beauty","b"}]
  """
  def transform(input) do
    input
      |> HashDict.to_list
      |> invert
      |> List.flatten
      |> HashDict.new
  end

  defp invert(pairs) do
    Enum.map(pairs, fn({key, values}) ->
      Enum.map(values, fn(value) -> {String.downcase(value), key} end)
    end)
  end
end
