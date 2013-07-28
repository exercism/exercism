package beersong

import (
	"bytes"
	"fmt"
)

func Verse(numberBottles int) string {
	return fmt.Sprintf("%s\n%s\n", bottles(numberBottles), action(numberBottles))
}

func Sing(args ...int) string {
	var buffer bytes.Buffer
	start := args[0]
	var end int

	if len(args) == 1 {
		end = 0
	} else {
		end = args[1]
	}

	for i := start; i >= end; i-- {
		buffer.WriteString(Verse(i) + "\n")
	}
	return buffer.String()
}

func bottles(numberBottles int) (b string) {
	switch {
	case numberBottles == 1:
		b = fmt.Sprintf("%d bottle of beer on the wall, %d bottle of beer.", numberBottles, numberBottles)
	case numberBottles == 0:
		b = "No more bottles of beer on the wall, no more bottles of beer."
	default:
		b = fmt.Sprintf("%d bottles of beer on the wall, %d bottles of beer.", numberBottles, numberBottles)
	}
	return
}

func action(numberBottles int) (r string) {
	switch {
  case numberBottles == 2:
    r = fmt.Sprintf("Take one down and pass it around, %d bottle of beer on the wall.", numberBottles-1)
	case numberBottles == 1:
		r = "Take it down and pass it around, no more bottles of beer on the wall."
	case numberBottles == 0:
		r = "Go to the store and buy some more, 99 bottles of beer on the wall."
	default:
		r = fmt.Sprintf("Take one down and pass it around, %d bottles of beer on the wall.", numberBottles-1)
	}
	return
}

/*
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
*/
