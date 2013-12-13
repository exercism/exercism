defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: HashDict.t
  def generate(max_factor, min_factor // 1) do
    Enum.reduce(min_factor..max_factor, HashDict.new, fn(x, dict) ->
      Enum.reduce(x..max_factor, dict, fn(y, products) ->
        cond do
          palindrome?(x * y) -> add_factor(products, x, y)
          true -> products
        end
      end)
    end)
    |> Enum.sort
  end

  defp palindrome?(number) do
    String.reverse(to_string(number)) == to_string(number)
  end

  defp add_factor(dict, x, y) do
    product = x * y
    HashDict.update(dict, product, 
      [[x, y]], fn(val) -> Enum.concat(val, [[x, y]]) end)
  end

end