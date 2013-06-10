class Bob

  def hey(something)
    if silent?(something)
      'Fine, be that way.'
    elsif question?(something)
      'Sure.'
    elsif shouting?(something)
      'Woah, chill out!'
    else
      'Whatever.'
    end
  end

  private

  def question?(s)
    s.end_with?('?')
  end

  def silent?(s)
    s.empty?
  end

  def shouting?(s)
    s.upcase == s
  end

end
