package accumulate

import (
	"fmt"
	"strings"
	"testing"
)

func echo(c string) string {
	return c
}

func capitalize(word string) string {
	return strings.Title(word)
}

var tests = []struct {
	expected    []string
	given       []string
	converter   func(string) string
	description string
}{
	{[]string{}, []string{}, echo, "echo"},
	{[]string{"echo", "echo", "echo", "echo"}, []string{"echo", "echo", "echo", "echo"}, echo, "echo"},
	{[]string{"First", "Letter", "Only"}, []string{"first", "letter", "only"}, capitalize, "capitalize"},
	{[]string{"HELLO", "WORLD"}, []string{"hello", "world"}, strings.ToUpper, "upcase"},
}

func TestAccumulate(t *testing.T) {
	for _, test := range tests {
		actual := Accumulate(test.given, test.converter)
		if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", test.expected) {
			t.Fatalf("Accumulate(%s, %#v): expected %s, actual %s", test.given, test.converter, test.expected, actual)
		} else {
			t.Logf("PASS: %s %v", test.description, test.given)
		}
	}
}

func BenchmarkAccumulate(b *testing.B) {
	b.StopTimer()
	for _, test := range tests {
		b.StartTimer()

		for i := 0; i < b.N; i++ {
			Accumulate(test.given, test.converter)
		}

		b.StopTimer()
	}
}
