class PigLatin
  def self.translate(phrase)
    phrase.split(' ').map do |word|
      PigLatin.new(word).translate
    end.join(' ')
  end

  def initialize(word)
    @word = word.downcase.gsub(/[^a-z]/,'')
  end

  def translate
    return (word + "ay") if it_starts_with_vowel_sound?
    start, remainder = parse_initial_consonant_sound_and_remainder
    remainder + start + "ay"
  end

private
  attr_reader :word

  def it_starts_with_vowel_sound?
    word.match /\A([aeiou]|y[^aeiou]|xr)/
  end

  def parse_initial_consonant_sound_and_remainder
    word.scan(/\A([^aeiou]?qu|[^aeiou]+)(.*)/).first
  end
end
