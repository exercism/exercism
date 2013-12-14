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
	expected  []string
	slice     []string
	converter func(string) string
}{
	{[]string{}, []string{}, echo},
	{[]string{"HELLO", "WORLD"}, []string{"hello", "world"}, strings.ToUpper},
}

func TestAccumulate(t *testing.T) {
	for _, test := range tests {
		actual := Accumulate(test.slice, test.converter)
		if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", test.expected) {
			t.Errorf("Allergies(%s, %s): expected %s, actual %s", test.slice, test.converter, test.expected, actual)
		}
	}
}
