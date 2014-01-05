package accumulate

import (
	"fmt"
	"strings"
	"testing"
)

func echo(c string) string {
	return c
}

var tests = []struct {
	expected    []string
	given       []string
	converter   func(string) string
	description string
}{
	{[]string{}, []string{}, echo, "echo"},
	{[]string{"HELLO", "WORLD"}, []string{"hello", "world"}, strings.ToUpper, "upcase"},
}

func TestAccumulate(t *testing.T) {
	for _, test := range tests {
		actual := Accumulate(test.given, test.converter)
		if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", test.expected) {
			t.Fatalf("Allergies(%s, %#v): expected %s, actual %s", test.given, test.converter, test.expected, actual)
		} else {
			t.Logf("PASS: %s %v", test.description, test.given)
		}
	}
}
