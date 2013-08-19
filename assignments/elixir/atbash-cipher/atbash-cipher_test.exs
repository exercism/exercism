Code.load_file("atbash.exs")
ExUnit.start

defmodule AtbashTest do
  use ExUnit.Case, async: true
  doctest Atbash

  test "encode no" do
    assert "ml" == Atbash.encode("no")
  end

  test "encode yes" do
    assert "bvh" == Atbash.encode("yes")
  end

  test "encode OMG" do
    assert "lnt" == Atbash.encode("OMG")
  end

  test "encode O M G" do
    assert "lnt" == Atbash.encode("O M G")
  end

  test "encode long word" do
    assert "nrmwy oldrm tob" == Atbash.encode("mindblowingly")
  end

  test "encode numbers" do
    assert "gvhgr mt123 gvhgr mt" == Atbash.encode("Testing, 1 2 3, testing.")
  end

  test "encode sentence" do
    assert "gifgs rhurx grlm" == Atbash.encode("Truth is fiction.")
  end

  test "encode all the things" do
    plaintext = "The quick brown fox jumps over the lazy dog."
    cipher = "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt"
    assert cipher == Atbash.encode(plaintext)
  end
end
