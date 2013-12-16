class School

  attr_reader :db
  def initialize
    @db = Hash.new { |db, grade| db[grade] = [] }
  end

  def add(student, grade)
    db[grade] << student
  end

  def grade(grade)
    db[grade]
  end

  def sort
    sorted = db.map { |grade, students| [ grade, students.sort ] }.sort
    Hash[sorted]
  end
end
