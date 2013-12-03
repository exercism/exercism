defmodule School do
	@moduledoc """
	Simulate students in a school.

	Each student is in a grade.
	"""

	@doc """
	Add a student to a particular grade in school.
	"""
	@spec add(HashDict, string, pos_integer) :: HashDict

	def add(db, name, grade) do

	end

	@doc """
	Return the names of the students in a particular grade.
	"""
	@spec grade(HashDict, pos_integer) :: [String]

	def grade(db, grade) do

	end

	@doc """
	Sorts the school by grade and name.
	"""
	@spec sort(HashDict) :: HashDict

	def sort(db) do

	end

end