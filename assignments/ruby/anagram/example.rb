class Anagram

  attr_reader :source
  def initialize(source)
    @source = AnagramSource.new(source)
  end

  def match(candidates)
    candidates.select do |candidate|
      source.anagram_of? candidate
    end
  end
end

class AnagramSource

  attr_reader :source
  def initialize(source)
    @source = source
  end

  def anagram_of?(word)
    !duplicate?(word) && fingerprint == canonicalize(word)
  end

  def duplicate?(word)
    word.downcase == source.downcase
  end

  def canonicalize(word)
    word.downcase.chars.sort
  end

  def fingerprint
    @fingerprint ||= canonicalize(source)
  end
end

