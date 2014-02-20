package wc

import (
	"reflect"
	"testing"
)

var testCases = []struct {
	description string
	input       string
	output      Histogram
}{
	{
		description: "a single word",
		input:       "word",
		output:      Histogram{"word": 1},
	},
	{
		description: "one of each",
		input:       "one of each",
		output:      Histogram{"one": 1, "of": 1, "each": 1},
	},
	{
		description: "multiple occurrences",
		input:       "one fish two fish red fish blue fish",
		output:      Histogram{"one": 1, "fish": 4, "two": 1, "red": 1, "blue": 1},
	},
	{
		description: "ignore punctuation",
		input:       "car : carpet as java : javascript!!&@$%^&",
		output:      Histogram{"car": 1, "carpet": 1, "as": 1, "java": 1, "javascript": 1},
	},
	{
		description: "including numbers",
		input:       "testing, 1, 2 testing",
		output:      Histogram{"testing": 2, "1": 1, "2": 1},
	},
	{
		description: "normalises case",
		input:       "go Go GO",
		output:      Histogram{"go": 3},
	},
}

func TestWordCount(t *testing.T) {
	for _, tt := range testCases {
		expected := tt.output
		actual := WordCount(tt.input)
		if !reflect.DeepEqual(actual, expected) {
			t.Fatalf("%s\n\tExpected: %v\n\tGot: %v", tt.description, expected, actual)
		} else {
			t.Logf("PASS: %s - WordCount(%s)", tt.description, tt.input)
		}
	}
}
