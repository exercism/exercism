package rnatranscription

import (
	"testing"
)

type rnaTest struct {
	input    string
	expected string
}

var rnaTests = []rnaTest{
	{"C", "C"},
	{"G", "G"},
	{"A", "A"},
	{"T", "U"},
	{"ACGTGGTCTTAA", "ACGUGGUCUUAA"},
}

func TestRnaTranscription(t *testing.T) {
	for _, test := range rnaTests {
		actual := ToRna(test.input)
		if actual != test.expected {
			t.Errorf("ToRna(%s): expected %s, actual %s", test.input, test.expected, actual)
		}
	}
}
