class Grains

  def square(number)
    2**(number-1)
  end

  def total
    sum = 0
    (1..64).each do |number|
      sum += square(number)
    end
    sum
  end

end
