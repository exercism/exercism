package beersong

import (
	"testing"
)

type beerSongVerseTest struct {
	num      int
	expected string
}

var beerSongVerseTests = []beerSongVerseTest{
	beerSongVerseTest{8, `8 bottles of beer on the wall, 8 bottles of beer.
Take one down and pass it around, 7 bottles of beer on the wall.
`},
	beerSongVerseTest{2, `2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.
`},
	beerSongVerseTest{1, `1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.
`},
	beerSongVerseTest{0, `No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.
`},
}

func TestBeerSongVerse(t *testing.T) {
	for _, test := range beerSongVerseTests {
		actual := Verse(test.num)
		if actual != test.expected {
			t.Errorf("Verse(%d):\nexpected\n%s\nactual\n%s", test.num, test.expected, actual)
		}
	}
}

func TestSingSeveralVerses(t *testing.T) {
	expected := `8 bottles of beer on the wall, 8 bottles of beer.
Take one down and pass it around, 7 bottles of beer on the wall.

7 bottles of beer on the wall, 7 bottles of beer.
Take one down and pass it around, 6 bottles of beer on the wall.

6 bottles of beer on the wall, 6 bottles of beer.
Take one down and pass it around, 5 bottles of beer on the wall.

`
	actual := Sing(8, 6)
	if actual != expected {
		t.Errorf("expected\n%s\nactual\n%s", expected, actual)
	}
}

func TestSingAllVerses(t *testing.T) {
	expected := `3 bottles of beer on the wall, 3 bottles of beer.
Take one down and pass it around, 2 bottles of beer on the wall.

2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.

1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.

`
	actual := Sing(3)

	if actual != expected {
		t.Errorf("expected\n[%s]\nactual\n[%s]", expected, actual)
	}
}
