Palindrome = Struct.new(:value, :factors)

class Palindromes

  attr_reader :range
  def initialize(options)
    max = options.fetch(:max_factor)
    min = options.fetch(:min_factor) { 1 }
    @range = (min..max)
  end

  def generate
    @palindromes = {}
    range.each do |i|
      range.each do |j|
        product = i * j
        if palindrome?(product)
          palindrome = @palindromes[product] || Palindrome.new(product, [])
          palindrome.factors << [i, j].sort
          palindrome.factors.uniq!
          @palindromes[product] = palindrome
        end
      end
    end
  end

  def palindrome?(number)
    number.to_s == number.to_s.reverse
  end

  def sort
    @palindromes.sort_by do |key, palindrome|
      key
    end
  end

  def largest
    sort.last[1]
  end

  def smallest
    sort.first[1]
  end

end
