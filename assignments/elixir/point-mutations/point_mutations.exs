defmodule DNA do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

	iex> DNA.hamming_distance('AAGTCATA', 'TAGCGATC')
	4
	"""
	@spec hamming_distance([char], [char]) :: non_neg_integer
	def hamming_distance(strand1, strand2) do
	end
end
