class School

  attr_reader :db
  def initialize
    @db ||= Hash.new { |students, grade| students[grade] = [] }
  end

  def add(student, grade)
    db[grade] << student
  end

  def grade(level)
    db[level] || []
  end

  def sort
    sorted = db.map { |grade, students| [ grade, students.sort ] }.sort
    Hash[sorted]
  end
end
