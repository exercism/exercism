class Anagram

  attr_reader :subject, :letters
  def initialize(subject)
    @subject = subject
    @letters = decompose subject
  end

  def match(words)
    words.select do |word|
      decompose(word) == letters
    end
  end

  private

  def decompose(s)
    s.chars.sort
  end
end

