defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    Enum.reduce(2..limit, [], fn(number, primes) ->
      if is_prime?(number, primes), do: [number|primes], else: primes end)
      |> Enum.reverse
  end

  @doc """
  Checks if a given number is prime based on a given list of known primes.
  """
  @spec is_prime?(non_neg_integer, [non_neg_integer]) :: boolean

  defp is_prime?(number, primes) do
    Enum.all?(primes, &(rem(number, &1) != 0))
  end
end