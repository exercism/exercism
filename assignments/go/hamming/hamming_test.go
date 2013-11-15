package hamming

import (
	"testing"
)

var testCases = []struct {
	expected         int
	strandA, strandB string
	description      string
}{
	{0, "GGACTGA", "GGACTGA", "no difference between identical strands"},
	{3, "ACT", "GGA", "complete hamming distance in small strand"},
	{9, "GGACGGATTCTG", "AGGACGGATTCT", "distance in off by one strand"},
	{1, "GGACG", "GGTCG", "small hamming distance in middle somewhere"},
	{2, "ACCAGGG", "ACTATGG", "larger distance"},
	{3, "AAACTAGGGG", "AGGCTAGCGGTAGGAC", "ignores extra length on other strand when longer"},
	{5, "GACTACGGACAGGGTAGGGAAT", "GACATCGCACACC", "ignores extra length on original strand when longer"},
}

func TestHamming(t *testing.T) {
	for _, tc := range testCases {

		observed := Distance(tc.strandA, tc.strandB)

		if tc.expected != observed {
			t.Fatalf(`%s:
expected: %v
observed: %v`,
				tc.description,
				tc.expected,
				observed,
			)
		}
	}
}
