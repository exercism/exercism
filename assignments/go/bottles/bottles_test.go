package bottles

import (
	"testing"
)

const verse8 = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n"
const verse3 = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n"
const verse2 = "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n"
const verse1 = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
const verse0 = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"

var testCases = []struct {
	description string
	verse       int
	expected    string
}{
	{"a typical verse", 8, verse8},
	{"another typical verse", 3, verse3},
	{"verse 2", 2, verse2},
	{"verse 1", 1, verse1},
	{"verse 0", 0, verse0},
}

func TestBottlesVerse(t *testing.T) {
	for _, tt := range testCases {
		actual := Verse(tt.verse)
		if actual != tt.expected {
			t.Fatalf("Verse(%d):\nexpected\n%s\nactual\n%s", tt.verse, tt.expected, actual)
		}
	}
}

func TestSeveralVerses(t *testing.T) {
	expected := `8 bottles of beer on the wall, 8 bottles of beer.
Take one down and pass it around, 7 bottles of beer on the wall.

7 bottles of beer on the wall, 7 bottles of beer.
Take one down and pass it around, 6 bottles of beer on the wall.

6 bottles of beer on the wall, 6 bottles of beer.
Take one down and pass it around, 5 bottles of beer on the wall.

`
	actual := Verses(8, 6)
	if actual != expected {
		t.Fatalf("expected\n%s\nactual\n%s", expected, actual)
	}
}

func TestSingAllVerses(t *testing.T) {
	expected := Verses(99, 0)
	actual := Sing()

	if expected != actual {
		msg := `
		  Did not sing the whole song correctly.

			Expected:

			%v

			Actual:

			%v
		`
		t.Fatalf(msg, expected, actual)
	}
}
