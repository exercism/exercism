class Anagram

  attr_reader :target
  def initialize(word)
    @target = AnagramWord.new(word)
  end

  def match(candidates)
    candidates.select do |candidate|
      target.anagram_of? candidate
    end
  end
end

class AnagramWord < String

  def anagram_of?(word)
    !duplicate?(word) && canonical_representation == canonicalize(word)
  end

  def duplicate?(word)
    word.downcase == downcase
  end

  def canonicalize(word)
    word.downcase.chars.sort
  end

  def canonical_representation
    @canonical_representation ||= canonicalize(self)
  end

end

