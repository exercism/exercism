package etl

import "testing"

type given map[int][]string
type expectation map[string]int

var transformTests = []struct {
	input  given
	output expectation
}{
	{
		given{1: {"A"}},
		expectation{"a": 1},
	},
	{
		given{1: {"A", "E", "I", "O", "U"}},
		expectation{"a": 1, "e": 1, "i": 1, "o": 1, "u": 1},
	},
	{
		given{
			1: {"A", "E"},
			2: {"D", "G"},
		},
		expectation{
			"a": 1,
			"e": 1,
			"d": 2,
			"g": 2,
		},
	},
	{
		given{
			1:  {"A", "E", "I", "O", "U", "L", "N", "R", "S", "T"},
			2:  {"D", "G"},
			3:  {"B", "C", "M", "P"},
			4:  {"F", "H", "V", "W", "Y"},
			5:  {"K"},
			8:  {"J", "X"},
			10: {"Q", "Z"},
		},
		expectation{
			"a": 1, "e": 1, "i": 1, "o": 1, "u": 1, "l": 1, "n": 1, "r": 1, "s": 1, "t": 1,
			"d": 2, "g": 2,
			"b": 3, "c": 3, "m": 3, "p": 3,
			"f": 4, "h": 4, "v": 4, "w": 4, "y": 4,
			"k": 5,
			"j": 8, "x": 8,
			"q": 10, "z": 10,
		},
	},
}

func equal(actual map[string]int, expectation map[string]int) bool {
	if len(actual) != len(expectation) {
		return false
	}

	for k, actualVal := range actual {
		expectationVal, present := expectation[k]

		if !present || actualVal != expectationVal {
			return false
		}
	}

	return true
}

func TestTranform(t *testing.T) {
	for _, tt := range transformTests {
		actual := Transform(tt.input)
		if !equal(actual, tt.output) {
			t.Fatalf("Transform(%v). Expected [%v], Actual [%v]", tt.input, tt.output, actual)
		}
	}
}

func BenchmarkTranform(b *testing.B) {
	b.StopTimer()
	for _, tt := range transformTests {
		b.StartTimer()

		for i := 0; i < b.N; i++ {
			Transform(tt.input)
		}

		b.StopTimer()
	}
}
