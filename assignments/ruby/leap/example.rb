require 'delegate'

class Year < SimpleDelegator

  def self.leap?(number)
    Year.new(number).leap?
  end

  def leap?
    divisible_by?(400) || divisible_by?(4) && !divisible_by?(100)
  end

  private

  def divisible_by?(i)
    (self % i) == 0
  end
end

