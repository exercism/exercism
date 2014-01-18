if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("grains.exs")
end

ExUnit.start

# NOTE: :math.pow/2 doesn't do what you'd expect:
# `:math.pow(2, 64) == :math.pow(2, 64) - 1` is true.
#
# It's best to avoid functions operating on floating point numbers for very
# large numbers.

defmodule GrainsTest do
  use ExUnit.Case

  test "square 1" do
    assert 1 == Grains.square(1)
  end

  test "square 2" do
    assert 2 == Grains.square(2)
  end

  test "square 3" do
    assert 4 == Grains.square(3)
  end

  test "square 4" do
    assert 8 == Grains.square(4)
  end

  test "square 16" do
    assert 32768 == Grains.square(16)
  end

  test "square 32" do
    assert 2147483648 == Grains.square(32)
  end

  test "square 64" do
    assert 9223372036854775808 == Grains.square(64)
  end

  test "total grains" do
    assert 18446744073709551615 == Grains.total
  end
end
