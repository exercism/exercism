class BeerSong
  def sing
    verses(99, 0)
  end

  def verses(starting, ending)
    (ending..starting).to_a.reverse.map {|n| verse(n) }.join("\n") + "\n"
  end

  def verse(number)
    if number == 0
      "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
    elsif number == 1
      "%s bottle of beer on the wall, %s bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n" % [number, number]
    elsif number == 2
      "%s bottles of beer on the wall, %s bottles of beer.\nTake one down and pass it around, %s bottle of beer on the wall.\n" % [number, number, number-1]
    else
      "%s bottles of beer on the wall, %s bottles of beer.\nTake one down and pass it around, %s bottles of beer on the wall.\n" % [number, number, number-1]
    end
  end
end
