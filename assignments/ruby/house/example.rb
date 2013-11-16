class House
  def verses(first, last)
    first.upto(last).map do |number|
      verse(number)
    end.join("\n") + "\n"
  end

  def verse(number)
    "This is" + "%s.\n" % chain(number).join('')
  end

  def chain(length)
    pieces[0..length-1].reverse.map do |subject, link|
      " the %s that %s" % [subject, link]
    end
  end

  def pieces
    [
      ['house', 'Jack built'],
      ['malt', 'lay in'],
      ['rat', 'ate'],
      ['cat', 'killed'],
      ['dog', 'worried'],
      ['cow with the crumpled horn', 'tossed'],
      ['maiden all forlorn', 'milked'],
      ['man all tattered and torn', 'kissed'],
      ['priest all shaven and shorn', 'married'],
      ['rooster that crowed in the morn', 'woke'],
      ['farmer sowing his corn', 'kept'],
      ['horse and the hound and the horn', 'belonged to'],
    ]
  end
end

