class Anagram

  attr_reader :subject
  def initialize(word)
    @subject = AnagramSubject.new(word)
  end

  def match(candidates)
    candidates.select do |candidate|
      subject.anagram_of? candidate
    end
  end
end

class AnagramSubject

  attr_reader :subject
  def initialize(subject)
    @subject = subject
  end

  def anagram_of?(word)
    !duplicate?(word) && fingerprint == canonicalize(word)
  end

  def duplicate?(word)
    word.downcase == subject.downcase
  end

  def canonicalize(word)
    word.downcase.chars.sort
  end

  def fingerprint
    @fingerprint ||= canonicalize(subject)
  end
end

