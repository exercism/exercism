defmodule Forth do
  @opaque evaluator :: any
  
  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do

  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t) :: evaluator
  def eval(ev, s) do
  
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t
  def format_stack(ev) do
  
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
