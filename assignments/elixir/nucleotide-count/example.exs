defmodule DNA do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> DNA.count('AATAA', ?A)
  4

  iex> DNA.count('AATAA', ?T)
  1
  """

  def count(strand, nucleotide) do
    Enum.count strand,  &1 == nucleotide
  end


  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> DNA.nucleotide_counts('AATAA')
  HashDict.new [{?A, 4}, {?T, 1}, {?C, 0}, {?G, 0}]
  """

  def nucleotide_counts(strand) do
    HashDict.new @nucleotides, &({&1, count(strand, &1)})
  end
end
