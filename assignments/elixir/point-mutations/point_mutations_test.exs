if System.get_env("EXERCISM_TEST_EXAMPLES") do
  Code.load_file("example.exs")
else
  Code.load_file("point_mutations.exs")
end

ExUnit.start

defmodule DNATest do
  use ExUnit.Case, async: true
  doctest DNA

  test "no difference between empty strands" do
    assert 0 == DNA.hamming_distance('', '')
  end

  test "no difference between identical strands" do
    # assert 0 == DNA.hamming_distance('GGACTGA', 'GGACTGA')
  end

  test "hamming distance in off by one strand" do
    # assert 19 == DNA.hamming_distance('GGACGGATTCTGACCTGGACTAATTTTGGGG', 'AGGACGGATTCTGACCTGGACTAATTTTGGGG')
  end

  test "small hamming distance in middle somewhere" do
    # assert 1 == DNA.hamming_distance('GGACG', 'GGTCG')
  end

  test "larger distance" do
    # assert 2 == DNA.hamming_distance('ACCAGGG', 'ACTATGG')
  end

  test "ignores extra length on other strand when longer" do
    # assert 3 == DNA.hamming_distance('AAACTAGGGG', 'AGGCTAGCGGTAGGAC')
  end

  test "ignores extra length on original strand when longer" do
    # assert 5 == DNA.hamming_distance('GACTACGGACAGGGTAGGGAAT', 'GACATCGCACACC')
  end
end
