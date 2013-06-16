class Chunk
  attr_reader :value, :magnitude
  def initialize(value, magnitude = nil)
    @value = value
    @magnitude = magnitude.nil? ? '' : " #{magnitude}"
  end

  def to_s
    return '' if zero?
    s = say_hundreds
    s << say_double_digits

    s << magnitude
  end

  private

  def say_hundreds
    return '' unless hundreds?
    "#{small_numbers[hundreds]} hundred"
  end

  def say_double_digits
    return '' if double_digits.zero?
    s = ''
    if double_digits < 20
      s << small_numbers[double_digits]
    else
      s << ' '
      s << decades[tens]
      unless ones.zero?
        s << '-'
        s << small_numbers[ones]
      end
    end
    s
  end

  def hundreds
    @hundreds ||= value / 100
  end

  def double_digits
    @double_digits ||= value % 100
  end

  def tens
    @tens ||= double_digits / 10
  end

  def ones
    @ones ||= double_digits % 10
  end

  def hundreds?
    not hundreds.zero?
  end

  def zero?
    value.zero?
  end

  def magnitude?
    !!magnitude
  end

  def small_numbers
    [nil] +
    %w(one two three four five
       six seven eight nine ten
       eleven twelve thirteen fourteen fifteen
       sixteen seventeen eighteen nineteen)
  end

  def decades
    [nil, nil] +
    %w(twenty thirty forty fifty
       sixty seventy eighty ninety)
  end

end

class Say

  ONE_BILLION = 10**9
  ONE_MILLION = 10**6

  attr_reader :value
  def initialize(value)
    @value = value
  end

  def in_english
    guard_range

    return 'zero' if value.zero?

    chunks.join(' ').squeeze(' ').strip
  end

  private

  def chunks
    billions, i = chop(value, ONE_BILLION)
    millions, i = chop(i, ONE_MILLION)
    thousands, i = chop(i, 1000)
    [
      Chunk.new(billions, 'billion'),
      Chunk.new(millions, 'million'),
      Chunk.new(thousands, 'thousand'),
      Chunk.new(i)
    ]
  end

  def chop(number, location)
    [number / location, number % location]
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

