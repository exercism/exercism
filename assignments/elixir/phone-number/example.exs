defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("123-456-7890")
  "1234567890"

  iex> Phone.number("+1 (303) 555-1212")
  "13035551212"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  def number(raw) do
    raw
      |> select_digits
      |> join
      |> validate
  end

  defp select_digits(string), do: Regex.scan %r{\d}, string
  defp join(digits), do: Enum.join digits, ""

  defp validate(number) do
    cond do
      valid?(number) -> number
      true -> "0000000000"
    end
  end

  defp valid_number_re, do: %r/^1?(\d{3})(\d{3})(\d{4})$/
  defp parts(number),   do: Enum.first Regex.scan valid_number_re, number
  defp valid?(number),  do: Regex.match? valid_number_re, number

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("123-456-7890")
  "123"

  iex> Phone.area_code("+1 (303) 555-1212")
  "303"

  iex> Phone.area_code("867.5309")
  "000"
  """
  def area_code(raw) do
    raw
      |> number
      |> _area_code
  end

  defp _area_code(number), do: Enum.first parts number

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("123-456-7890")
  "(123) 456-7890"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  def pretty(raw) do
    raw
      |> number
      |> _pretty
  end

  defp _pretty(number) do
    [area, exchange, subscriber] = parts number
    "(#{area}) #{exchange}-#{subscriber}"
  end
end
