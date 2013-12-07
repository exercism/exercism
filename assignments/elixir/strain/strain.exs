defmodule Strain do

  @doc """
  Keep all entries in a collection that return true for a given function.

  Using filter would work, but don't use it.
  """
  @spec keep(Enum.t, (any -> as_boolean(term))) :: list
  def keep(collection, function) do
  
  end
  
  @doc """
  DIscard all entries in a collection that return true for a given function.

  Using reject would work, but don't use it.
  """
  @spec discard(Enum.t, (any -> as_boolean(term))) :: list
  def discard(collection, function) do
      
  end

end