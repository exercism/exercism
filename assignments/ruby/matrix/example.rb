class Matrix
  attr_reader :rows, :columns
  def initialize(input)
    @rows = extract_rows(input)
    @columns = extract_columns(rows)
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
