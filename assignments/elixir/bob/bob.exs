defmodule Message do

  def silent?(input),   do: "" == String.strip(input)
  def shouting?(input), do: input == String.upcase(input) && letters?(input)
  def question?(input), do: String.ends_with?(input, "?")

  defp letters?(input), do: Regex.match?(%r/[a-zA-Z]+/, input)
end

defmodule Teenager do
  import Message, only: [silent?: 1, shouting?: 1, question?: 1]

  def hey(input) do
    cond do
      silent?(input)   -> "Fine. Be that way!"
      shouting?(input) -> "Woah, chill out!"
      question?(input) -> "Sure."
      true             -> "Whatever."
    end
  end
end
