Code.load_file("school.exs")
ExUnit.start

defmodule SchoolTest do
  use ExUnit.Case, async: true
  doctest School

  def db, do: HashDict.new

  test "add student" do
    actual = School.add(db, "Aimee", 2)
    assert actual == HashDict.new [{2, ["Aimee"]}]
  end

  test "add more students in same class" do
    actual = db
      |> School.add("James", 2)
      |> School.add("Blair", 2)
      |> School.add("Paul", 2)

    # assert actual == HashDict.new [{2, ["James", "Blair", "Paul"]}]
  end

  test "add students to different grades" do
    actual = db
      |> School.add("Chelsea", 3)
      |> School.add("Logan", 7)

    # assert actual == HashDict.new [{3, ["Chelsea"]}, {7, ["Logan"]}]
  end

  test "get students in a grade" do
    actual = db
      |> School.add("Franklin", 5)
      |> School.add("Bradley", 5)
      |> School.add("Jeff", 1)
      |> School.grade(5)

    # assert ["Franklin", "Bradley"] == actual
  end

  test "get students in a non existant grade" do
    # assert [] == School.grade(db, 1)
  end

  test "sort school" do
    actual = db
      |> School.add("Jennifer", 4)
      |> School.add("Kareem", 6)
      |> School.add("Christopher", 4)
      |> School.add("Kyle", 3)
      |> School.sort

    expected = HashDict.new [
      {3, ["Kyle"]},
      {4, ["Christopher", "Jennifer"]},
      {6, ["Kareem"]}
    ]

    # assert expected == actual
  end
end
