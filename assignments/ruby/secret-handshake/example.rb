class SecretHandshake

  attr_reader :digits
  def initialize(decimal)
    begin
      @digits = decimal.to_s(2).reverse.chars.collect(&:to_i)
    rescue ArgumentError
      @digits = 0
    end
  end

  def commands
    handshake = []
    (0..3).each do |index|
      if digits[index] == 1
        handshake << signals[index]
      end
    end
    if digits[4] == 1
      handshake.reverse
    else
      handshake
    end
  end

  private

  def signals
    ["wink", "double blink", "close your eyes", "jump"]
  end

end
