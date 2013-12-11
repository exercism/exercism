package leap

import (
	"testing"
)

var testCases = []struct {
	year        int
	expected    bool
	description string
}{
	{1996, true, "a vanilla leap year"},
	{1997, false, "a normal year"},
	{1900, false, "a century"},
	{2400, true, "an exceptional century"},
}

func TestLeapYears(t *testing.T) {
	for _, test := range testCases {
		observed := IsLeapYear(test.year)
		if observed != test.expected {
			t.Fatalf("%v is %s", test.year, test.description)
		}
	}
}
