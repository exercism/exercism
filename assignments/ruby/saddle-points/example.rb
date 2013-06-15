class Matrix
  attr_reader :rows, :columns
  def initialize(input)
    @rows = extract_rows(input)
    @columns = extract_columns(rows)
  end

  def saddle_points
    unless @saddle_points
      coordinates = []
      rows.each_with_index do |row, j|
        max = row.max
        row.each_with_index do |number, i|
          min = columns[i].min
          if number == max && number == min
            coordinates << [i, j]
          end
        end
      end
      @saddle_points = coordinates
    end
    @saddle_points
  end

  private

  def extract_rows(s)
    s.split("\n").map do |row|
      row.split(' ').map(&:to_i)
    end
  end

  def extract_columns(rows)
    columns = []
    rows.each do |row|
      row.each_with_index do |number, i|
        columns[i] ||= []
        columns[i] << number
      end
    end
    columns
  end
end
