defmodule Accumulate do

  @doc """
  Returns a collection after applying a given function to every element in a provided collection.
  
  Try to do this exercise without using map!
  """
  
  @spec accumulate(Enum.t, (any -> as_boolean(term))) :: list
  def accumulate(collection, function) do
    Enum.reduce(collection, [], fn(element, acc) ->
      [function.(element)|acc]
    end) |> Enum.reverse
  end

end