class WordProblem
  attr_reader :question
  def initialize(question)
    @question = question
  end

  def answer
    if too_complicated?
      raise ArgumentError.new("I don't understand the question")
    end
    unless @answer
      @answer = n1.send(operation, n2)
      if chain?
        @answer = @answer.send(operation2, n3)
      end
    end
    @answer
  end

  private

  def too_complicated?
    matches.nil?
  end

  def matches
    @matches ||= question.match(pattern)
  end

  def pattern
    operations = '(plus|minus|multiplied by|divided by)'
    /What is (-?\d+) #{operations} (-?\d+)( #{operations} (-?\d+))?\?/
  end

  def operation
    case matches[2]
    when 'plus' then :+
    when 'minus' then :-
    when 'multiplied by' then :*
    when 'divided by' then :/
    end
  end

  def operation2
    case matches[5]
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

  def n3
    matches[6].to_i
  end

  def chain?
    !!matches[4]
  end

end

