defmodule Squares do
  @moduledoc """
  Calculate sum of squares, square of sums, difference between two sums from 1 to a given end number.
  """

  @doc """
  Calculate sum of squares from 1 to a given end number.
  """
  @spec sum_of_squares(pos_integer) :: pos_integer

  def sum_of_squares(1) do
    1
  end

  def sum_of_squares(number) do
    (number * number) + sum_of_squares(number - 1)
  end

  @doc """
  Calculate square of sums from 1 to a given end number.
  """
  @spec square_of_sums(pos_integer) :: pos_integer

  def square_of_sums(number) do
    sum_to(number) * sum_to(number)
  end

  defp sum_to(1) do
    1
  end

  defp sum_to(number) do
    number + sum_to(number - 1)
  end

  @doc """
  Calculate difference between sum of squares and square of sums from 1 to a given end number.
  """
  @spec difference(pos_integer) :: pos_integer

  def difference(number) do
    square_of_sums(number) - sum_of_squares(number)
  end

end