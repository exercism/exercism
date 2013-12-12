package etl

import "testing"

type in map[int][]string
type out map[string]int

var transformTests = []struct {
	input    in
	expected out
}{
	{
		in{1: {"A"}},
		out{"a": 1},
	},
	{
		in{1: {"A", "E", "I", "O", "U"}},
		out{"a": 1, "e": 1, "i": 1, "o": 1, "u": 1},
	},
	{
		in{
			1: {"A", "E"},
			2: {"D", "G"},
		},
		out{
			"a": 1,
			"e": 1,
			"d": 2,
			"g": 2,
		},
	},
	{
		in{
			1:  {"A", "E", "I", "O", "U", "L", "N", "R", "S", "T"},
			2:  {"D", "G"},
			3:  {"B", "C", "M", "P"},
			4:  {"F", "H", "V", "W", "Y"},
			5:  {"K"},
			8:  {"J", "X"},
			10: {"Q", "Z"},
		},
		out{
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

func equal(actual map[string]int, expected map[string]int) bool {
	if len(actual) != len(expected) {
		return false
	}

	for k, actualVal := range actual {
		expectedVal, present := expected[k]

		if !present || actualVal != expectedVal {
			return false
		}
	}

	return true
}

func TestTranform(t *testing.T) {
	for _, tt := range transformTests {
		actual := Transform(tt.input)
		if !equal(actual, tt.expected) {
			t.Fatalf("Transform(%v). Expected [%v], Actual [%v]", tt.input, tt.expected, actual)
		}
	}
}
