class Queens

  attr_reader :white, :black
  def initialize(positions = {})
    @white = positions.fetch(:white) { [0, 3] }
    @black = positions.fetch(:black) { [7, 3] }
    raise ArgumentError if white == black
  end

  def attack?
    on_horizontal? || on_vertical? || on_diagonal?
  end

  def to_s
    board = []
    (0..7).each do |row|
      positions = []
      (0..7).each do |column|
        positions << draw(row, column)
      end
      board[row] = positions.join(" ")
    end
    board.join("\n")
  end

  private

  def on_horizontal?
    white[0] == black[0]
  end

  def on_vertical?
    white[1] == black[1]
  end

  def on_diagonal?
    white_diff.abs == black_diff.abs
  end

  def black_diff
    black[1] - black[0]
  end

  def white_diff
    white[1] - white[0]
  end

  def draw(row, column)
    case [row, column]
    when white then "W"
    when black then "B"
    else
      "O"
    end
  end

end
