Code.load_file("nth_prime.exs")
ExUnit.start

defmodule NthPrimeTest do
  use ExUnit.Case, async: true

  test "first prime" do
    assert 2 == Prime.nth(1)
  end

  test "second prime" do
    assert 3 == Prime.nth(2)
  end

  test "sixth prime" do
    assert 13 == Prime.nth(6)
  end

  test "100th prime" do
    assert 541 == Prime.nth(100)
  end

  test "weird case" do
    catch_error Prime.nth(0)
  end

end