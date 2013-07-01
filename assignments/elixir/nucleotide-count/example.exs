defmodule DNA do
  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> DNA.count('AATAA', 'A')
  4

  iex> DNA.count('AATAA', 'T')
  1
  """

  def count(dna, [n | _]),  do: count(dna, n)
  def count([], _),         do: 0
  def count([n | tail], n), do: 1 + count(tail, n)
  def count([_ | tail], n), do: count(tail, n)

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> DNA.nucleotide_counts('AATAA')
  HashDict.new [{'A', 4}, {'T', 1}, {'C', 0}, {'G', 0}]
  """
  def nucleotide_counts(dna) do
    HashDict.new Enum.map 'ATCG', fn(n) -> { [n | []], count(dna, n) } end
  end
end
