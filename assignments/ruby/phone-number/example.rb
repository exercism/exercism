class Phone

  attr_reader :number
  def initialize(number)
    @number = clean(number)
  end

  def area_code
    number[0..2]
  end

  # technically, the central office (exchange) code
  def exchange_code
    number[3..5]
  end

  def subscriber_number
    number[6..9]
  end

  def to_s
    "(#{area_code}) #{exchange_code}-#{subscriber_number}"
  end

  private

  def clean(number)
    number = number.gsub(/[^0-9]/, "")
    normalized(number)
  end

  def normalized(number)
    if valid?(number)
      return number[/(\d{10})\z/, 1]
    else
      return "0000000000"
    end
  end

  def valid?(number)
    return true if number.length == 10
    return true if number.length == 11 && number.start_with?("1")
    return false
  end

end

