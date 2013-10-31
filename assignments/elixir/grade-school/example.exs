defmodule School do
  def add(db, student, grade) do
    HashDict.update db, grade, [student], &([ student | &1 ])
  end

  def grade(db, grade) do
    HashDict.get db, grade, []
  end

  def sort(db) do
    db
      |> Enum.map(fn({k, v}) -> {k, Enum.sort(v)} end)
      |> Enum.sort
      |> HashDict.new
  end
end
