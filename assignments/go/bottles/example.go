package bottles

import (
	"bytes"
	"fmt"
)

func Verse(numberBottles int) string {
	return fmt.Sprintf("%s\n%s\n", bottles(numberBottles), action(numberBottles))
}

func Verses(start, stop int) string {
	var buffer bytes.Buffer
	for i := start; i >= stop; i-- {
		buffer.WriteString(Verse(i) + "\n")
	}
	return buffer.String()
}

func Sing() string {
	var buffer bytes.Buffer
	for i := 99; i >= 0; i-- {
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
