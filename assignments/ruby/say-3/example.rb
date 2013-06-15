class Chunk
  attr_reader :value, :magnitude
  def initialize(value, magnitude = nil)
    @value = value
    @magnitude = magnitude.nil? ? '' : " #{magnitude}"
  end

  def to_s
    return '' if zero?
    "#{value}#{magnitude}"
  end

  private

  def zero?
    value.zero?
  end

  def magnitude?
    !!magnitude
  end

end

class Say

  attr_reader :value
  def initialize(value)
    @value = value
  end

  def in_english
    guard_range

    return '0' if value.zero?

    chunks.join(' ').squeeze(' ').strip
  end

  private

  def chunks
    [
      Chunk.new(billions, 'billion'),
      Chunk.new(millions, 'million'),
      Chunk.new(thousands, 'thousand'),
      Chunk.new(hundreds)
    ]
  end

  def billions
    value / 1_000_000_000
  end

  def millions
    value % 1_000_000_000 / 1_000_000
  end

  def thousands
    value % 1_000_000 / 1_000
  end

  def hundreds
    value % 1_000
  end

  def guard_range
    unless in_range?
      message = 'Number must be between 0 and 999,999,999,999 inclusive.'
      raise ArgumentError.new(message)
    end
  end

  def in_range?
    value >= 0 && value < 10**12
  end
end

