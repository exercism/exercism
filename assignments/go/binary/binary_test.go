package binary

import "testing"

var testCases = []struct {
	binary   string
	expected int
}{
	{"1", 1},
	{"10", 2},
	{"11", 3},
	{"100", 4},
	{"1001", 9},
	{"10001101000", 1128},
	{"12", 0},
}

func TestBinary(t *testing.T) {
	for _, tt := range testCases {
		actual := ToDecimal(tt.binary)
		if actual != tt.expected {
			t.Fatalf("ToDecimal(%v): expected %v, actual %v", tt.binary, tt.expected, actual)
		}
	}
}
