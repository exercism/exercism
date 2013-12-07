defmodule Strain do

  @doc """
  Keep all entries in a collection that return true for a given function.

  Using filter would work, but don't use it.
  """
  @spec keep(Enum, function) :: List
  
  def keep(collection, function) do
    Enum.reduce(collection, [], fn(entry, kept) ->
      if function.(entry), do: [entry|kept], else: kept
    end) |> Enum.reverse
  end
  
  @doc """
  DIscard all entries in a collection that return true for a given function.

  Using reject would work, but don't use it.
  """
  @spec discard(Enum, function) :: List

  def discard(collection, function) do
    Enum.reduce(collection, [], fn(entry, kept) ->
      unless function.(entry), do: [entry|kept], else: kept
    end) |> Enum.reverse
  end

end