package bottles

import (
	"fmt"
	"strings"
)

func Sing() (result string) {
	return Verses(99, 0)
}

func Verses(start, end int) string {
	a := []string{}
	for i := end; i < start+1; i++ {
		a = append([]string{Verse(i)}, a...)
	}
	return strings.Join(a, "\n") + "\n"
}

func Verse(n int) (result string) {
	if n == 0 {
		result = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
	} else if n == 1 {
		result = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
	} else if n == 2 {
		result = "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n"
	} else {
		result = fmt.Sprintf("%d bottles of beer on the wall, %d bottles of beer.\nTake one down and pass it around, %d bottles of beer on the wall.\n", n, n, n-1)
	}
	return result
}
