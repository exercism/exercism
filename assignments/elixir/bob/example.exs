defmodule Teenager do
  @doc """
  Answers to `hey` like a teenager.

  ## Examples

  iex> Teenager.hey("")
  "Fine. Be that way!"

  iex> Teenager.hey("Do you like math?")
  "Sure."

  iex> Teenager.hey("HELLO!")
  "Woah, chill out!"

  iex> Teenager.hey("Coding is cool.")
  "Whatever."
  """

  def hey(input) do
    cond do
      silent?(input)   -> "Fine. Be that way!"
      shouting?(input) -> "Woah, chill out!"
      question?(input) -> "Sure."
      true             -> "Whatever."
    end
  end

  defp silent?(input),   do: input == ""
  defp shouting?(input), do: input == String.upcase input
  defp question?(input), do: "?" == String.last input
end
