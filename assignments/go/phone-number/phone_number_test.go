package phonenumber

import (
	"testing"
)

type test struct {
	input    string
	expected string
}

func assertAllTestsPass(t *testing.T, tests []test, testFunc func(string) string) {
	for _, test := range tests {
		actual := testFunc(test.input)
		if test.expected != actual {
			t.Errorf("Number(%s): expected [%s], actual: [%s]", test.input, test.expected, actual)
		}
	}
}

func benchAllTests(b *testing.B, tests []test, testFunc func(string) string) {
	//b.StopTimer()
	for _, test := range tests {
		//b.StartTimer()

		testFunc(test.input)

		//b.StopTimer()
	}
}

var numberTests = []test{
	{"(123) 456-7890", "1234567890"},
	{"123.456.7890", "1234567890"},
	{"1234567890", "1234567890"},
	{"21234567890", "0000000000"},
	{"123456789", "0000000000"},
}

func TestNumber(t *testing.T) {
	assertAllTestsPass(t, numberTests, Number)
}

func BenchmarkNumber(b *testing.B) {
	for i := 0; i < b.N; i++ {
		benchAllTests(b, numberTests, Number)
	}
}

var areaCodeTests = []test{
	{"1234567890", "123"},
	{"213.456.7890", "213"},
}

func TestAreaCode(t *testing.T) {
	assertAllTestsPass(t, areaCodeTests, AreaCode)
}

func BenchmarkAreaCode(b *testing.B) {
	for i := 0; i < b.N; i++ {
		benchAllTests(b, areaCodeTests, AreaCode)
	}
}

var formatTests = []test{
	{"1234567890", "(123) 456-7890"},
	{"11234567890", "(123) 456-7890"},
}

func TestFormat(t *testing.T) {
	assertAllTestsPass(t, formatTests, Format)
}

func BenchmarkFormat(b *testing.B) {
	for i := 0; i < b.N; i++ {
		benchAllTests(b, formatTests, Format)
	}
}
