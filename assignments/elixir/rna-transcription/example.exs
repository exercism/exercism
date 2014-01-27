defmodule DNA do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> DNA.to_rna('ACTG')
  'UGAC'
  """
  def to_rna(dna) do
    Enum.map dna, &transcribe(&1)
  end

  defp transcribe(?C), do: ?G
  defp transcribe(?G), do: ?C
  defp transcribe(?A), do: ?U
  defp transcribe(?T), do: ?A
end
