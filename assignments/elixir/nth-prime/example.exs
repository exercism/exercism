defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) do
    if count < 1, do: raise ArgumentError
    nth(count, 1000)
  end

  defp nth(count, max) do
    primes = primes_to(max)
    cond do
      Enum.count(primes) < count -> nth(count, max * 4)
      true -> Enum.at(primes, count - 1)
    end
  end

  defp primes_to(limit) do
    Enum.reduce(2..limit, [], fn(number, primes) ->
      if is_prime?(number, primes), do: [number|primes], else: primes end)
      |> Enum.reverse
  end

  defp is_prime?(number, primes) do
    Enum.all?(primes, &(rem(number, &1) != 0))
  end

end