defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(HashDict.new [{"a", ["ABILITY", "AARDVARK"]}, {"b", ["BALLAST", "BEAUTY"]}])
  HashDict.new [{"ability", "a"},{"aardvark","a"},{"ballast","b"},{"beauty","b"}]
  """
  @spec transform(Dict.t) :: HashDict.t
  def transform(input) do

  end
end
