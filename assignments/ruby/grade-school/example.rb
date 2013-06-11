class School

  def initialize(name)
  end

  def db
    @db ||= {}
  end

  def add(student, grade)
    db[grade] ||= []
    db[grade] << student
  end

  def grade(level)
    db[level] || []
  end

  def sort
    sorted = {}
    db.keys.sort.each do |level|
      sorted[level] = grade(level).sort
    end
    sorted
  end
end
