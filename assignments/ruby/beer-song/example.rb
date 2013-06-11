class Beer
  def sing(first, last = 0)
    s = ""
    first.downto(last).each do |number|
      s << verse(number)
      s << "\n"
    end
    s
  end

  def verse(number)
    s = ""
    s << "#{bottles(number).capitalize} of beer on the wall, "
    s << "#{bottles(number)} of beer.\n"
    s << action(number)
    s << next_bottle(number)
  end

  def next_bottle(current_verse)
    "#{bottles(next_verse(current_verse))} of beer on the wall.\n"
  end

  def action(current_verse)
    if current_verse == 0
      "Go to the store and buy some more, "
    else
      "Take #{current_verse == 1 ? "it" : "one"} down and pass it around, "
    end
  end

  def next_verse(current_verse)
    current_verse == 0 ? 99 : (current_verse - 1)
  end

  def bottles(number)
    if number == 0
      "no more bottles"
    elsif number == 1
      "1 bottle"
    else
      "#{number} bottles"
    end
  end

end
