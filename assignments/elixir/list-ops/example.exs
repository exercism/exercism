defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  # 
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically important`) and so shouldn't be used either.
 
  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)

  defp do_count([], acc), do: acc
  defp do_count([_|t], acc), do: do_count(t, acc+1)

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])

  defp do_reverse([], acc), do: acc
  defp do_reverse([h|t], acc), do: do_reverse(t, [h|acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, []) |> reverse()

  defp do_map([], _, acc), do: acc
  defp do_map([h|t], f, acc), do: do_map(t, f, [f.(h)|acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, []) |> reverse()

  defp do_filter([], _, acc), do: acc
  defp do_filter([h|t], f, acc) do
    if f.(h) do
      do_filter(t, f, [h|acc])
    else
      do_filter(t, f, acc)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([h|t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: do_append(reverse(a), b)

  defp do_append([], b), do: b
  defp do_append([h|t], b), do: do_append(t, [h|b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: reverse(ll) |> reduce([], &(append(&1, &2)))
end
