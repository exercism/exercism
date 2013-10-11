### Example 1 ###

class Bob
  def hey(drivel)
    case
    when taciturn?(drivel)
      'Fine. Be that way!'
    when forceful?(drivel)
      'Woah, chill out!'
    when curious?(drivel)
      'Sure.'
    else
      'Whatever.'
    end
  end

  private

  def taciturn?(s)
    s.strip.empty?
  end

  def curious?(s)
    s.end_with?('?')
  end

  def forceful?(s)
    s =~ /[A-Z]/ && s.upcase == s
  end
end

### Example 2 ###

class Alice
  def hey(drivel)
    respond_to Phrase.new(drivel)
  end

  def respond_to(phrase)
    case
    when phrase.silent?
      'Fine. Be that way!'
    when phrase.loud?
      'Woah, chill out!'
    when phrase.quizzical?
      'Sure.'
    else
      'Whatever.'
    end
  end
end

class Phrase

  attr_reader :source
  def initialize(drivel)
    @source = drivel.to_s.strip
  end

  def quizzical?
    source.end_with?('?')
  end

  def loud?
    source =~ /[A-Z]/ && source.upcase == source
  end

  def silent?
    source.empty?
  end
end

### Example 3 ###

class Charlie

  def hey(drivel)
    answerer(drivel).reply
  end

  private

  def answerer(drivel)
    handlers.find {|answer| answer.handles?(drivel)}.new
  end

  def handlers
    [AnswerSilence, AnswerShout, AnswerQuestion, AnswerDefault]
  end

end

class AnswerSilence

  def self.handles?(input)
    input.strip.empty?
  end

  def reply
    'Fine. Be that way!'
  end

end

class AnswerQuestion

  def self.handles?(input)
    input.end_with?('?')
  end

  def reply
    'Sure.'
  end

end

class AnswerShout

  def self.handles?(input)
    input =~ /[A-Z]/ && input.upcase == input
  end

  def reply
    'Woah, chill out!'
  end

end

class AnswerDefault

  def self.handles?(input)
    true
  end

  def reply
    'Whatever.'
  end

end

### Example 4 ###

class David
  Handler = Struct.new(:response, :pattern)

  HANDLERS = {
    :nothing   => Handler.new("Fine. Be that way!", ->(i) { i.strip.empty? }),
    :yell      => Handler.new("Woah, chill out!",   ->(i) { i.eql?(i.upcase) && i =~ /[A-Z]/ }),
    :question  => Handler.new("Sure.",              ->(i) { i.end_with?("?") }),
    :statement => Handler.new("Whatever.",          ->(i) { true })
  }

  def hey(input)
    respond(select_handler(input))
  end

  def respond(handler)
    handler.response
  end

  def select_handler(input)
    handlers.values.find { |r| r.pattern.call(input) }
  end

  def handlers
    HANDLERS
  end
end
