Code.load_file("palindrome_products.exs")
ExUnit.start

defmodule PalindromeProductsTest do
  use ExUnit.Case, async: true

  test "largest palindrome from single digit factors" do
    palindromes = Palindromes.generate(9)
    assert 9 == List.last(Dict.keys(palindromes))
    assert [[1, 9], [3, 3]] == Dict.fetch!(palindromes, 9)
  end

  test "largest palindrome from double digit factors" do
    palindromes = Palindromes.generate(99, 10)
    assert 9009 == List.last(Dict.keys(palindromes))
    assert [[91, 99]] == Dict.fetch!(palindromes, 9009)
  end

  test "smallest palindrome from double digit factors" do
    palindromes = Palindromes.generate(99, 10)
    assert 121 == Enum.first(Dict.keys(palindromes))
    assert [[11, 11]] == Dict.fetch!(palindromes, 121)
  end

  test "largest palindrome from triple digit factors" do
    palindromes = Palindromes.generate(999, 100)
    assert 906609 == List.last(Dict.keys(palindromes))
    assert [[913, 993]] == Dict.fetch!(palindromes, 906609)
  end

  test "smallest palindromes from triple digit factors" do
    palindromes = Palindromes.generate(999, 100)
    assert 10201 == Enum.first(Dict.keys(palindromes))
    assert [[101, 101]] == Dict.fetch!(palindromes, 10201)

  end


end