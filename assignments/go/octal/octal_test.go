package octal

import "testing"

type testCase struct {
	input    string
	expected int64
}

var testCases = []testCase{
	{"1", 1},
	{"10", 8},
	{"1234567", 342391},
	{"carrot", 0},
}

func TestToDecimal(t *testing.T) {
	for _, test := range testCases {
		actual := ToDecimal(test.input)
		if actual != test.expected {
			t.Errorf("ToDecimal(%s): expected[%d], actual [%d]", test.input, test.expected, actual)
		}
	}
}
