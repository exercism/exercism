Code.load_file("forth.exs")
ExUnit.start

defmodule ForthTest do
  use ExUnit.Case

  test "no input, no stack" do
    s = Forth.new |> Forth.format_stack
    assert s == ""
  end

  test "numbers just get pushed onto the stack" do
    s = Forth.new
        |> Forth.eval("1 2 3 4 5")
        |> Forth.format_stack
    assert s == "1 2 3 4 5"
  end

  test "non-word characters are separators" do
    # Note the Ogham Space Mark ( ), this is a spacing character.
    s = Forth.new
        |> Forth.eval("1\0002\0013\n4\r5 6\t7")
        |> Forth.format_stack
    assert s == "1 2 3 4 5 6 7"
  end

  test "basic arithmetic" do
    s = Forth.new
        |> Forth.eval("1 2 + 4 -")
        |> Forth.format_stack
    assert s == "-1"
    s = Forth.new
        |> Forth.eval("2 4 * 3 /") # integer division
        |> Forth.format_stack
    assert s == "2"
  end

  test "division by zero" do
    assert_raise Forth.DivisionByZero, fn ->
      Forth.new |> Forth.eval("4 2 2 - /")
    end
  end

  test "dup" do
    s = Forth.new
        |> Forth.eval("1 DUP")
        |> Forth.format_stack
    assert s == "1 1"
    s = Forth.new
        |> Forth.eval("1 2 Dup")
        |> Forth.format_stack
    assert s == "1 2 2"
    assert_raise Forth.StackUnderflow, fn ->
      Forth.new |> Forth.eval("dup")
    end
  end
  
  test "drop" do
    s = Forth.new
        |> Forth.eval("1 drop")
        |> Forth.format_stack
    assert s == ""
    s = Forth.new
        |> Forth.eval("1 2 drop")
        |> Forth.format_stack
    assert s == "1"
    assert_raise Forth.StackUnderflow, fn ->
      Forth.new |> Forth.eval("drop")
    end
  end

  test "swap" do
    s = Forth.new
        |> Forth.eval("1 2 swap")
        |> Forth.format_stack
    assert s == "2 1"
    s = Forth.new
        |> Forth.eval("1 2 3 swap")
        |> Forth.format_stack
    assert s == "1 3 2"
    assert_raise Forth.StackUnderflow, fn ->
      Forth.new |> Forth.eval("1 swap")
    end
    assert_raise Forth.StackUnderflow, fn ->
      Forth.new |> Forth.eval("swap")
    end
  end
  
  test "over" do
    s = Forth.new
        |> Forth.eval("1 2 over")
        |> Forth.format_stack
    assert s == "1 2 1"
    s = Forth.new
        |> Forth.eval("1 2 3 over")
        |> Forth.format_stack
    assert s == "1 2 3 2"
    assert_raise Forth.StackUnderflow, fn ->
      Forth.new |> Forth.eval("1 over")
    end
    assert_raise Forth.StackUnderflow, fn ->
      Forth.new |> Forth.eval("over")
    end
  end

  test "defining a new word" do
    s = Forth.new
        |> Forth.eval(": dup-twice dup dup ;")
        |> Forth.eval("1 dup-twice")
        |> Forth.format_stack
    assert s == "1 1 1"
  end

  test "redefining an existing word" do
    s = Forth.new
        |> Forth.eval(": foo dup ;")
        |> Forth.eval(": foo dup dup ;")
        |> Forth.eval("1 foo")
        |> Forth.format_stack
    assert s == "1 1 1"
  end
  
  test "redefining an existing built-in word" do
    s = Forth.new
        |> Forth.eval(": swap dup ;")
        |> Forth.eval("1 swap")
        |> Forth.format_stack
    assert s == "1 1"
  end

  test "defining words with odd characters" do
    s = Forth.new
        |> Forth.eval(": € 220371 ; €")
        |> Forth.format_stack
    assert s == "220371"
  end
  
  test "defining a number" do
    assert_raise Forth.InvalidWord, fn ->
      Forth.new |> Forth.eval(": 1 2 ;")
    end
  end

  test "calling a non-existing word" do
    assert_raise Forth.UnknownWord, fn ->
      Forth.new |> Forth.eval("1 foo")
    end
  end
end
