package binary

import "testing"

type binaryTest struct {
	binary   string
	expected int
}

var binaryTests = []binaryTest{
	{"1", 1}, {"10", 2}, {"11", 3},
	{"100", 4}, {"1001", 9}, {"10001101000", 1128},
	{"12", 0},
}

func TestBinary(t *testing.T) {
	for _, test := range binaryTests {
		actual := ToDecimal(test.binary)
		if actual != test.expected {
			t.Errorf("ToDecimal(%d): expected %d, actual %d", test.binary, test.expected, actual)
		}
	}
}
