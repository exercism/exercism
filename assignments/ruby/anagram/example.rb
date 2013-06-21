class Anagram

  attr_reader :letters
  def initialize(subject)
    @letters = decompose subject
  end

  def match(candidates)
    candidates.select do |candidate|
      decompose(candidate) == letters
    end
  end

  private

  def decompose(s)
    s.chars.sort
  end
end

