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
    @matches ||= question.match(/What is (-?\d+) (plus|minus) (-?\d+)( (plus|minus) (-?\d+))?\?/)
  end

  def operation
    matches[2] == 'plus' ? :+ : :-
  end

  def operation2
    matches[5] == 'plus' ? :+ : :-
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

