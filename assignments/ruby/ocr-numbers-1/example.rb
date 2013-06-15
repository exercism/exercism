class OCR

  attr_reader :text, :rows
  def initialize(text)
    @text = text
    @rows = text.split("\n")
  end

  def convert
    converted = []
    (0...numbers_per_line).step(3) do |position|
      converted << char(position)
    end
    converted.join
  end

  private

  def char(position)
    patterns[pattern_at(position)] || garble
  end

  def pattern_at(position)
    [
      rows[0][position,3],
      rows[1][position,3],
      rows[2][position,3],
      rows[3][position,3]
    ]
  end

  def numbers_per_line
    rows[0].length
  end

  def garble
    '?'
  end

  def patterns
    {
      [" _ ", "| |", "|_|","   "] => "0",
      ["   ", "  |", "  |", "   "] => "1"
    }
  end

end
