defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    Enum.to_list(2..limit) |> do_primes([]) |> Enum.reverse
  end

  defp do_primes([], primes), do: primes
  defp do_primes([ candidate | rest ], primes) do
    candidates = Enum.reject(rest, &(rem(&1, candidate) == 0))
    do_primes(candidates, [ candidate | primes ])
  end

end
