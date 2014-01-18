defmodule CustomSet do
  # This lets the compiler check that all Set callback functions have been
  # implemented.
  @behaviour Set

  # Use a list as set implementation. This is horribly slow compared to other
  # approaches, but simple.

  # Wrapper for the internal list
  defrecordp :set, __MODULE__, list: []

  def new() do
    set()
  end

  def new(coll) do
    Enum.reduce(coll, set(), fn x, s -> put(s, x) end)
  end

  ## Set callbacks
  def delete(s, x) do
    wrap(List.delete(unwrap(s), x))
  end

  def difference(a, b) do
    wrap(Enum.filter_map(diff(a, b), &(match?({:a_only, _}, &1)), &(elem(&1, 1))))
  end

  def disjoint?(a, b) do
    not Enum.any?(diff(a, b), &(match?({:both, _}, &1)))
  end

  def empty(_) do
    set() 
  end

  def equal?(a, b) do
    unwrap(a) === unwrap(b)
  end

  def intersection(a, b) do
    wrap(Enum.filter_map(diff(a, b), &(match?({:both, _}, &1)), &(elem(&1, 1))))
  end

  def member?(s, x) do
    :lists.member(x, unwrap(s))
  end

  def put(s, x) do
    case do_put(unwrap(s), x, []) do
      nil -> s # Element already in list
      l   -> wrap(l)
    end
  end

  defp do_put([], x, acc) do
    :lists.reverse([x|acc])
  end
  defp do_put(l = [h|t], x, acc) do
    # Maintain a sorted order
    cond do
      x === h ->
        nil
      lt_strict(x, h) ->
        :lists.reverse(acc) ++ [x|l]
      true ->
        do_put(t, x, [h|acc])
    end
  end

  def size(s) do
    length(unwrap(s))
  end

  def subset?(a, b) do
    not Enum.any?(diff(a, b), &(match?({:a_only, _}, &1)))
  end

  def to_list(s) do
    unwrap(s)
  end

  def union(a, b) do
    wrap(Enum.sort(Enum.map(diff(a, b), &(elem(&1, 1)))))
  end

  @compile { :inline, wrap: 1, unwrap: 1 }
    
  defp wrap(l) do
    set(list: l)
  end

  defp unwrap(s) do
    set(s, :list)
  end

  defp diff(a, b) do
    la = unwrap(a)
    lb = unwrap(b)
    do_diff(la, lb, [])
  end

  defp do_diff([], [], acc), do: :lists.reverse(acc)
  defp do_diff([ha|ta], [], acc), do: do_diff(ta, [], [{:a_only, ha} | acc])
  defp do_diff([], [hb|tb], acc), do: do_diff([], tb, [{:b_only, hb} | acc])
  defp do_diff(a = [ha|ta], b = [hb|tb], acc) do
    cond do
      lt_strict(ha, hb) ->
        do_diff(ta, b, [{:a_only, ha} | acc])
      lt_strict(hb, ha) ->
        do_diff(a, tb, [{:b_only, hb} | acc])
      true ->
        do_diff(ta, tb, [{:both, ha} | acc])
    end
  end

  # Total version of ordering. Normally 1 < 1.0 and 1 > 1.0 are both false,
  # which matches the fact that 1 == 1.0. However with strict comparison (===)
  # 1 === 1.0 is false so one of 1 < 1.0 and 1 > 1.0 should be true. This
  # provides for that.
  defp lt_strict(a, b) when is_float(a) and is_integer(b), do: false
  defp lt_strict(a, b) when is_integer(a) and is_float(b), do: true
  defp lt_strict(a, b), do: a < b
end

defimpl Inspect, for: CustomSet do
  import Kernel, except: [inspect: 2]
  import Inspect.Algebra
  # Deal with the deprecation of Kernel.to_doc
  if not { :to_doc, 2 } in Inspect.Algebra.__info__(:functions) do
    def to_doc(x, opts), do: Kernel.inspect(x, opts)
  end
  def inspect(s, opts) do
    concat ["#<CustomSet ", to_doc(CustomSet.to_list(s), opts), ">"]
  end
end
