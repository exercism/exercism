package beer_song

import "testing"

var versesTests = []struct {
	expected string
	starting int
	ending   int
}{
	{"8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n\n", 8, 6},
}

var verseTests = []struct {
	expected string
	number   int
}{
	{"No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n", 0},
	{"2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n", 2},
	{"1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n", 1},
	{"3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n", 3},
	{"8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n", 8},
}

func TestSing(t *testing.T) {
	actual := Sing()
	expected := Verses(99, 0)
	if actual != expected {
		t.Errorf("Sing(): expected %s, actual %s", actual, expected)
	}
}

func TestVerses(t *testing.T) {
	for _, test := range versesTests {
		actual := Verses(test.starting, test.ending)
		if actual != test.expected {
			t.Errorf("Verses(%d, %d): expected %s, actual %s", test.starting, test.ending, test.expected, actual)
		}
	}
}

func TestVerse(t *testing.T) {
	for _, test := range verseTests {
		actual := Verse(test.number)
		if actual != test.expected {
			t.Errorf("Verses(%d): expected %s, actual %s", test.number, test.expected, actual)
		}
	}
}
