defrecord Graph, attrs: [], nodes: [], edges: []

defmodule Dot do
  # Normally matching on keywords is a bad idea as keyword lists can have
  # several orders (i.e. `[a: 1, b: 2]` and `[b: 2, a: 1]`). But in this case
  # only one keyword is allowed, so it's safe.
  defmacro graph([do: ast]) do
    g = do_graph(ast)
    Macro.escape(
      Graph[attrs: Enum.sort(g.attrs),
            nodes: Enum.sort(g.nodes),
            edges: Enum.sort(g.edges)])
  end

  defp do_graph(nil) do
    Graph[]
  end
  defp do_graph({:__block__, _, stmts}) do
    Enum.reduce(stmts, Graph[], &do_stmt/2)
  end
  defp do_graph(stmt) do
    do_stmt(stmt, Graph[])
  end

  defp do_stmt(stmt = {:graph, _, [kws]}, g) when is_list(kws) do
    if Keyword.keyword?(kws) do
      g.update(attrs: (Code.eval_quoted(kws) |> elem(0)) ++ g.attrs)
    else
      raise_invalid_stmt(stmt)
    end
  end
  defp do_stmt({atom, _, nil}, g) when is_atom(atom) and atom != :-- do
    g.update(nodes: [{atom, []} | g.nodes])
  end
  defp do_stmt(stmt = {atom, _, [kws]}, g)
    when is_atom(atom) and atom != :-- and is_list(kws) do
    if Keyword.keyword?(kws) do
      g.update(nodes: [{atom, Code.eval_quoted(kws) |> elem(0)} | g.nodes])
    else
      raise_invalid_stmt(stmt)
    end
  end
  defp do_stmt({:--, _, [{a, _, nil}, {b, _, nil}]}, g) 
    when is_atom(a) and is_atom(b) do
    g.update(edges: [{a, b, []} | g.edges])
  end
  defp do_stmt(stmt = {:--, _, [{a, _, nil}, {b, _, [kws]}]}, g)
    when is_atom(a) and is_atom(b) and is_list(kws) do
    if Keyword.keyword?(kws) do
      g.update(edges: [{a, b, Code.eval_quoted(kws) |> elem(0)} | g.edges])
    else
      raise_invalid_stmt(stmt)
    end
  end
  defp do_stmt(stmt, _) do
    raise_invalid_stmt(stmt)
  end

  defp raise_invalid_stmt(stmt) do
    raise ArgumentError, message: "Invalid statement: #{inspect stmt}"
  end

end
