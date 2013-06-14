class PigLatin

  def self.translate(phrase)
    phrase.split(" ").map do |word|
      head, tail = word.scan(/\A([^aeiou]?qu|[^aeiou]*)(.*)/).first
      tail + head + suffix
    end.join " "
  end

  def self.suffix
    "ay"
  end

end
