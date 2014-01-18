if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("palindrome_products.exs")
end

ExUnit.start

defmodule PalindromeProductsTest do
  use ExUnit.Case, async: true

  test "largest palindrome from single digit factors" do
    palindromes = Palindromes.generate(9)
    assert 9 == palindromes |> Dict.keys |> Enum.sort |> List.last
    assert [[1, 9], [3, 3]] == palindromes[9]
  end

  test "largest palindrome from double digit factors" do
    palindromes = Palindromes.generate(99, 10)
    assert 9009 == palindromes |> Dict.keys |> Enum.sort |> List.last
    assert [[91, 99]] == palindromes[9009]
  end

  test "smallest palindrome from double digit factors" do
    palindromes = Palindromes.generate(99, 10)
    assert 121 == palindromes |> Dict.keys |> Enum.sort |> hd
    assert [[11, 11]] == palindromes[121]
  end

  test "largest palindrome from triple digit factors" do
    palindromes = Palindromes.generate(999, 100)
    assert 906609 == palindromes |> Dict.keys |> Enum.sort |> List.last
    assert [[913, 993]] == palindromes[906609]
  end

  test "smallest palindromes from triple digit factors" do
    palindromes = Palindromes.generate(999, 100)
    assert 10201 == palindromes |> Dict.keys |> Enum.sort |> hd
    assert [[101, 101]] == palindromes[10201]

  end


end
