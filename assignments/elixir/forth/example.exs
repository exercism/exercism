defmodule Forth do
  defrecord State, stack: [], defs: HashDict.new, input: [] do
    @moduledoc false
  end

  @opaque evaluator :: State.t

  defmodule Primitives do
    def defs do
      HashDict.new([
        { "+",    &math_op(&1, :+) },
        { "-",    &math_op(&1, :-) },
        { "*",    &math_op(&1, :*) },
        { "/",    &math_op(&1, :/) },
        { "DUP",  &dup/1 },
        { "DROP", &drop/1 },
        { "SWAP", &swap/1 },
        { "OVER", &over/1 }
      ])
    end

    defp math_op(s, op) do
      { s, [a, b] } = pop(s, 2)
      res = case op do
        :+             -> a + b
        :-             -> a - b
        :*             -> a * b
        :/ when b == 0 -> raise Forth.DivisionByZero
        :/             -> div(a, b)
      end
      push(s, res)
    end

    defp dup(s) do
      { s, [x] } = pop(s, 1)
      s.stack([x,x|s.stack])
    end

    defp drop(s) do
      { s, _ } = pop(s, 1)
      s
    end

    defp swap(s) do
      { s, [a, b] } = pop(s, 2)
      s.stack([a,b|s.stack])
    end

    defp over(s) do
      case s.stack do
        [b, a | t] -> s.stack([a, b, a | t])
        _          -> raise Forth.StackUnderflow
      end
    end

    # Pops and returns in reverse order (so the patterns catching those args can
    # be written in the way you'd think about them in Forth).
    defp pop(s, n) do
      { stack, acc } = do_pop(s.stack, n, [])
      { s.stack(stack), acc }
    end

    defp do_pop(stack, 0, acc), do: { stack, acc }
    defp do_pop([h|t], n, acc), do: do_pop(t, n-1, [h|acc])
    defp do_pop([], _, _), do: raise Forth.StackUnderflow

    defp push(s, x), do: s.stack([x|s.stack])
  end
  
  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    State[defs: Primitives.defs]
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t) :: evaluator
  def eval(ev, s) do
    do_eval(ev.input(ev.input ++ tokenize(s)))
  end

  defp do_eval(s = State[input: []]), do: s
  defp do_eval(s = State[stack: stack, input: [h|t]]) when is_integer(h) do
    do_eval(s.update(stack: [h|stack], input: t))
  end
  defp do_eval(s = State[input: [":",h|t]]) do
    if is_binary(h) do
      w = String.upcase(h)
      # Find the ";", otherwise just return the current state and wait for the
      # user to finish the definition.
      case Enum.split_while(t, &(&1 != ";")) do
        { _, [] }         -> s # ";" not found
        { ws, [";" | r] } ->
          do_eval(s.update(defs: Dict.put(s.defs, w, ws), input: r))
      end
    else
      # User tried to define a number.
      raise Forth.InvalidWord, word: h
    end
  end
  defp do_eval(s = State[defs: defs, input: [h|t]]) when is_binary(h) do
    w = String.upcase(h)
    case defs[w] do
      nil                   -> raise Forth.UnknownWord, word: w
      d when is_function(d) -> do_eval(d.(s.input(t)))
      # To evaluate a user defined function we'll just put the function
      # definition in the input list. That should do the trick.
      d when is_list(d)     -> do_eval(s.input(d ++ t))
    end
  end

  defp tokenize(s) do
    Regex.scan(%r/[\p{L}\p{N}\p{S}\p{P}]+/, s)
    |> Stream.map(&hd/1)
    |> Enum.map(fn t ->
         case Integer.parse(t) do
           { i, "" } -> i
           _         -> t
         end
       end)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t
  def format_stack(State[stack: stack]) do
    # Enum.join calls to_string on each element, no need to do that ourselves.
    Enum.reverse(stack) |> Enum.join(" ")
  end
end

defexception Forth.StackUnderflow do
  def message(_), do: "stack underflow"
end

defexception Forth.InvalidWord, word: nil do
  def message(e), do: "invalid word: #{inspect e.word}"
end

defexception Forth.UnknownWord, word: nil do
  def message(e), do: "unknown word: #{inspect e.word}"
end

defexception Forth.DivisionByZero do
  def message(_), do: "division by zero"
end
