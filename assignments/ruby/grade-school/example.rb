class School

  attr_reader :name, :db
  def initialize(name)
    @name = name
    @db ||= Hash.new { |students, grade| students[grade] = [] }
  end

  def add(student, grade)
    db[grade] << student
  end

  def grade(level)
    db[level] || []
  end

  def sort
    sorted = db.map { |grade, students| [ grade, students.sort ] }
    Hash[sorted]
  end
end
