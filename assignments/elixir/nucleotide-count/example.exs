defmodule DNA do

  @empty_nucleotide_table HashDict.new([{?A, 0}, {?C, 0}, {?G, 0}, {?T, 0}])

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> DNA.count('AATAA', ?A)
  4

  iex> DNA.count('AATAA', ?T)
  1
  """

  def count(dna, nucleotide) do
    Enum.count dna,  &1 == nucleotide
  end


  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> DNA.nucleotide_counts('AATAA')
  HashDict.new [{?A, 4}, {?T, 1}, {?C, 0}, {?G, 0}]
  """

  def nucleotide_counts(nucleotides) do
    List.foldl(nucleotides, @empty_nucleotide_table, fn(nucleotide, acc) ->
      HashDict.update(acc, nucleotide, 1, &1+1)
    end)
  end


end