defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    case { length(a), length(b) } do
      { la, lb } when la < lb ->
        if is_sublist(a, b, la, lb), do: :sublist, else: :unequal
      { la, lb } when la > lb ->
        if is_sublist(b, a, lb, la), do: :superlist, else: :unequal
      _ -> 
        if a == b, do: :equal, else: :unequal
    end
  end

  defp is_sublist(_, _, len_a, len_b) when len_a > len_b, do: false
  defp is_sublist([], _, _, _), do: true  # empty is sublist of all non-empty
  defp is_sublist(a, b=[_|t], len_a, len_b) do
    if try_is_sublist(a, b) do
      true
    else
      is_sublist(a, t, len_a, len_b-1)
    end
  end

  defp try_is_sublist([], _), do: true
  defp try_is_sublist([x|at], [x|bt]), do: try_is_sublist(at, bt)
  defp try_is_sublist(_, _), do: false
end
