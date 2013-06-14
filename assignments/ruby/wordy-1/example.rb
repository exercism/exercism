class Calculator
  def ask(question)
    question.match(/What is (-?\d+) plus (-?\d+)?/) do |m|
      m[1].to_i + m[2].to_i
    end
  end
end

