defmodule Phone do
  @moduledoc """
  Utilities to work with phone numbers.
  """

  @bad_result "0000000000"

  @doc """
  Clean up a phone number.

  Returns 0000000000 if the phone number is bad.
  """
  @spec number(String.t) :: String.t
  def number(str) do
    r = String.to_char_list!(str)
        |> Enum.filter(&(&1 >= ?0 and &1 <= ?9))
        |> do_number()
    case r do
      nil -> @bad_result
      l   -> String.from_char_list!(l)
    end
  end

  defp do_number(l) when length(l) == 10, do: l
  defp do_number([?1|l]) when length(l) == 10, do: l
  defp do_number(_), do: nil

  @doc """
  Get the area code of a phone number.
  
  The area code is the first three digits of a cleaned up phone number.
  """
  @spec area_code(String.t) :: String.t
  def area_code(str) do
    number(str) |> String.slice(0, 3)
  end

  @doc """
  Pretty print a phone number.
  """
  @spec pretty(String.t) :: String.t
  def pretty(str) do
    c = number(str)
    "(#{String.slice(c, 0, 3)}) #{String.slice(c, 3, 3)}-#{String.slice(c,6,4)}"
  end
end
