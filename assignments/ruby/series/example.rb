class Series

  def initialize(numeric_string)
    @digits = convert_to_digits(numeric_string)
  end

  def slices(length)
    if length > digits.length
      raise ArgumentError.new('Not enough digits')
    end
    result = []
    i = -1
    begin
      i += 1
      i2 = i + length - 1
      result << digits[i..i2]
    end while i2 < digits.size - 1
    result
  end

  private

  attr_reader :digits

  def convert_to_digits(s)
    s.chars.to_a.map(&:to_i)
  end
end

