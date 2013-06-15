class Triangle
  attr_reader :depth
  def initialize(depth)
    @depth = depth
  end

  def rows
    triangle = []
    0.upto(depth-1) do |row|
      values = []
      if row == 0
        values << 1
      else
        length = (triangle[row-1] || []).size
        0.upto(length) do |position|
          left = position.zero? ? 0 : triangle[row-1][position-1]
          right = (triangle[row-1] || [])[position] || 0
          values << (left + right)
        end
      end
      triangle[row] = values
    end
    triangle
  end
end
