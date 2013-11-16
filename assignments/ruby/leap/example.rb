class Year

  attr_reader :number
  def initialize(number)
    @number = number.to_i
  end

  def leap?
    (vanilla? && !century?) || exceptional_century?
  end

  private

  def vanilla?
    (number % 4) == 0
  end

  def century?
    (number % 100) == 0
  end

  def exceptional_century?
    (number % 400) == 0
  end

end

