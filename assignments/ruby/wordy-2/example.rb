class WordProblem
  attr_reader :question
  def initialize(question)
    @question = question
  end

  def answer
    if too_complicated?
      raise ArgumentError.new("I don't understand the question")
    end
    @answer ||= n1.send(operation, n2)
  end

  private

  def too_complicated?
    matches.nil?
  end

  def matches
    @matches ||= question.match(/What is (-?\d+) (plus|minus|multiplied by|divided by) (-?\d+)\?/)
  end

  def operation
    case matches[2]
    when 'plus' then :+
    when 'minus' then :-
    when 'multiplied by' then :*
    when 'divided by' then :/
    end
  end

  def n1
    matches[1].to_i
  end

  def n2
    matches[3].to_i
  end

end


