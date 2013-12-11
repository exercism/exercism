defmodule Triplet do

  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet) do
    Enum.reduce(triplet, 0, &(&1 + &2))
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet) do
    Enum.reduce(triplet, 1, &(&1 * &2))
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    (a * a) + (b * b) == (c * c)
  end

  defp select?(triplet) do
    pythagorean?(triplet)
  end

  defp select?(triplet, sum) do
    pythagorean?(triplet) && sum(triplet) == sum
  end

  @doc """
  Generates a list of pythagorean triplets from a given min (or 1 if no min) to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min // 1, max) do
    Enum.reduce(min..max, [], fn(f1, acc) ->
      Enum.reduce(f1..max, [], fn(f2, acc) ->
        Enum.reduce(f2..max, [], fn(f3, acc) ->
          if select?([f1, f2, f3]) do
            [[f1, f2, f3]|acc]
          else acc
          end
        end) |> Enum.concat(acc)
      end) |> Enum.concat(acc)
    end) |> Enum.reverse
  end

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer) :: [list(non_neg_integer
  def generate(min, max, sum) do
    Enum.reduce(min..max, [], fn(f1, acc) ->
      Enum.reduce(f1..max, [], fn(f2, acc) ->
        Enum.reduce(f2..max, [], fn(f3, acc) ->
          if select?([f1, f2, f3], sum) do
            [[f1, f2, f3]|acc]
          else acc
          end
        end) |> Enum.concat(acc)
      end) |> Enum.concat(acc)
    end) |> Enum.reverse
  end
end