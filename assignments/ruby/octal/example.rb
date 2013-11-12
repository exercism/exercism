class Octal

  BASE = 8

  attr_reader :digits
  def initialize(decimal)
    @digits = decimal.reverse.chars
  end

  def to_decimal
    decimal = 0
    digits.each_with_index do |digit, index|
      return 0 unless valid_chars.include? digit
      decimal += digit.to_i * BASE**index
    end
    decimal
  end

  def valid_chars
    [*('0'..(BASE-1).to_s)]
  end
end
