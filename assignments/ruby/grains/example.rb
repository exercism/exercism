class Grains

  def square(number)
    2**(number-1)
  end

  def total
    @total ||= (1..64).inject(0) do |sum, number|
      sum + square(number)
    end
  end

end
