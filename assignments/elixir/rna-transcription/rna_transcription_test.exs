Code.load_file("dna.exs")
ExUnit.start

defmodule DNATest do
  use ExUnit.Case, async: true
  doctest DNA

  test "transcribes cytidine unchanged" do
    assert 'C' == DNA.to_rna('C')
  end

  test "transcribes guanosine unchanged" do
    # assert 'G' == DNA.to_rna('G')
  end

  test "transcribes adenosine unchanged" do
    # assert 'A' == DNA.to_rna('A')
  end

  test "transcribes thymidine to uracil" do
    # assert 'U' == DNA.to_rna('T')
  end

  test "it transcribes all occurrences of thymidine to uracil" do
    # assert 'ACGUGGUCUUAA' == DNA.to_rna('ACGTGGTCTTAA')
  end
end
