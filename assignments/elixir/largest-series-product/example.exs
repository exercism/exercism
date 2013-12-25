defmodule Series do

  @doc """
  Splits up the given string of numbers into an array of integers.
  """
  @spec digits(String.t) :: [non_neg_integer]
  def digits("") do
    []
  end

  def digits(number_string) do
    String.split(number_string, "", trim: true)
    |> Enum.reduce([], fn(char, acc) -> [binary_to_integer(char)|acc] end)
    |> Enum.reverse
  end

  @doc """
  Generates sublists of a given size from a given string of numbers.
  """
  @spec slices(String.t, non_neg_integer) :: [list(non_neg_integer)]
  def slices(number_string, size) do
    digits = digits(number_string)
    Enum.chunks(digits, size, 1)
  end

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer
  def largest_product("", _) do
    1
  end

  def largest_product(number_string, size) do
    slices = slices(number_string, size)
    Enum.map(slices, &Enum.reduce(&1, fn(x, acc) -> x * acc end))
    |> Enum.max
  end

end
