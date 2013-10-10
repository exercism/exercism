class Binary

  attr_reader :digits
  def initialize(decimal)
    @digits = normalize(decimal).reverse.chars.collect(&:to_i)
  end

  def to_decimal
    digits.each_with_index.inject(0) do |decimal, (digit, index)|
      decimal + digit * 2**index
    end
  end

  private

  def normalize(string)
    string.match(/[^01]/) ? "0" : string
  end
end
