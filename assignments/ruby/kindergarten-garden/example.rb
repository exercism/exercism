class Garden

  attr_reader :pots, :students
  def initialize(diagram, students = default_children)
    @pots = parse(diagram)
    @students = students.sort
    assign_pots
  end

  def default_children
    %w(Alice Bob Charlie David Eve Fred Ginny Harriet Ileana Joseph Kincaid Larry)
  end

  private

  def parse(diagram)
    diagram.split("\n").map do |row|
      row.split("").map do |sign|
        plants[sign]
      end
    end
  end

  def plants
    {
      'G' => :grass,
      'V' => :violets,
      'R' => :radishes,
      'C' => :clover
    }
  end

  def assign_pots
    students.each_with_index do |student, i|
      instance_eval "def #{student.downcase}; position = #{i}*2; pots[0][position,2] + pots[1][position,2]; end"
    end
  end

end
