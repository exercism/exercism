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
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
  
  end


  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> DNA.nucleotide_counts('AATAA')
  HashDict.new [{?A, 4}, {?T, 1}, {?C, 0}, {?G, 0}]
  """
  @spec nucleotide_counts([char]) :: HashDict.t
  def nucleotide_counts(strand) do
 
  end
end
