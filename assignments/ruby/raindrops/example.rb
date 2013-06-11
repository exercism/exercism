class Raindrops

  def convert(i)
    unless pling?(i) || plang?(i) || plong?(i)
      return i.to_s
    end

    s = ''
    s << 'Pling' if pling?(i)
    s << 'Plang' if plang?(i)
    s << 'Plong' if plong?(i)
    s
  end

  private

  def pling?(number)
    (number % 3) == 0
  end

  def plang?(number)
    (number % 5) == 0
  end

  def plong?(number)
    (number % 7) == 0
  end

end

