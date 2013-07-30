package phonenumber

import (
	"testing"
)

type test struct {
	input    string
	expected string
}

func assertAllTestsPass(t *testing.T, tests []test, testFunc func(string)string) {
  for _, test := range tests {
    actual := testFunc(test.input)
    if test.expected != actual {
      t.Errorf("Number(%s): expected [%s], actual: [%s]", test.input, test.expected, actual)
    }
  }
}

var numberTests = []test{
	test{"(123) 456-7890", "1234567890"},
	test{"123.456.7890", "1234567890"},
	test{"1234567890", "1234567890"},
	test{"21234567890", "0000000000"},
	test{"123456789", "0000000000"},
}

func TestNumber(t *testing.T) {
	assertAllTestsPass(t, numberTests, Number)
}

var areaCodeTests = []test{
	test{"1234567890", "123"},
	test{"213.456.7890", "213"},
}

func TestAreaCode(t *testing.T) {
	assertAllTestsPass(t, areaCodeTests, AreaCode)
}

var formatTests = []test{
  test{"1234567890", "(123) 456-7890"},
  test{"11234567890", "(123) 456-7890"},
}

func TestFormat(t *testing.T) {
  assertAllTestsPass(t, formatTests, Format)
}
