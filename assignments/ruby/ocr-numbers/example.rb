class OCR

  attr_reader :text
  def initialize(text)
    @text = text.split("\n")
  end

  def convert
    numbers = []
    each_row do |row|
      numbers << values_in_row(row)
    end
    format(numbers)
  end

  private

  def format(numbers)
    numbers.map {|values| values.join}.join(',')
  end

  def values_in_row(row)
    values = []
    each_column do |column|
      values << value_at(row, column)
    end
    values
  end

  def each_row
    (0...row_count).step(4) do |row|
      yield row
    end
  end

  def each_column
    (0...column_count).step(3) do |column|
      yield column
    end
  end

  def value_at(row, column)
    value(pattern_at(row, column)) || garble
  end

  def pattern_at(row, column)
    [
      text[row][column,3],
      text[row+1][column,3],
      text[row+2][column,3],
      text[row+3][column,3]
    ]
  end

  def column_count
    text.first.length
  end

  def row_count
    text.length
  end

  def garble
    "?"
  end

  def value(pattern)
    {
      [" _ ", "| |", "|_|", "   "] => "0",
      ["   ", "  |", "  |", "   "] => "1",
      [" _ ", " _|", "|_ ", "   "] => "2",
      [" _ ", " _|", " _|", "   "] => "3",
      ["   ", "|_|", "  |", "   "] => "4",
      [" _ ", "|_ ", " _|", "   "] => "5",
      [" _ ", "|_ ", "|_|", "   "] => "6",
      [" _ ", "  |", "  |", "   "] => "7",
      [" _ ", "|_|", "|_|", "   "] => "8",
      [" _ ", "|_|", " _|", "   "] => "9"
    }[pattern]
  end

end
