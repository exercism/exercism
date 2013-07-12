defmodule DNA do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> DNA.to_rna('ACTG')
  'ACUG'
  """
  def to_rna(dna) do
    Enum.map dna, transcribe &1
  end

  # T -> U
  defp transcribe(?T), do: ?U
  defp transcribe(n),  do: n
end
