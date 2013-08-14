class Binary(object):
    def __init__(self, binary_string):
        self.binary_string = [
            int(char) for char
            in reversed(binary_string)
            if char in '10'
        ]

    def __int__(self):
        return sum([
            digit * (2 ** index) for index, digit
            in enumerate(self.binary_string)
        ])

# class Binary

#   attr_reader :digits
#   def initialize(decimal)
#     @digits = decimal.reverse.chars.collect(&:to_i)
#   end

#   def to_decimal
#     decimal = 0
#     digits.each_with_index do |digit, index|
#       decimal += digit * 2**index
#     end
#     decimal
#   end
# end
