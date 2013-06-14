class Octal

  BASE = 8

  attr_reader :digits
  def initialize(decimal)
    @digits = decimal.reverse.chars.collect(&:to_i)
  end

  def to_decimal
    decimal = 0
    digits.each_with_index do |digit, index|
      decimal += digit * BASE**index
    end
    decimal
  end
end
