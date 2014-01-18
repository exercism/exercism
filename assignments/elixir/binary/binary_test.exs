if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("binary.exs")
end

ExUnit.start

defmodule BinaryTest do
  use ExUnit.Case, async: true

  test "binary 1 is decimal 1" do
    assert 1 == Binary.to_decimal("1")
  end

  test "binary 10 is decimal 2" do
    assert 2 == Binary.to_decimal("10")
  end

  test "binary 11 is decimal 3" do
    assert 3 == Binary.to_decimal("11")
  end

  test "binary 100 is decimal 4" do
    assert 4 == Binary.to_decimal("100")
  end

  test "binary 1001 is decimal 9" do
    assert 9 == Binary.to_decimal("1001")
  end

  test "binary 11010 is decimal 26" do
    assert 26 == Binary.to_decimal("11010")
  end

  test "binary 10001101000 is decimal 1128" do
    assert 1128 == Binary.to_decimal("10001101000")
  end

  test "invalid binary is decimal 0" do
    assert 0 == Binary.to_decimal("carrot")
  end
end
