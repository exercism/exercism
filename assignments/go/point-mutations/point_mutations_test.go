package pointmutations

import "testing"

var tests = []struct {
	expected int
	strand1  string
	strand2  string
}{
	{0, "", ""},               // empty
	{0, "GGACTGA", "GGACTGA"}, //identical
	{1, "GGACG", "GGTCG"},
	{2, "ACCAGGG", "ACTATGG"},
	{3, "AAACTAGGGG", "AGGCTAGCGGTAGGAC"},          // 2nd longer
	{5, "GACTACGGACAGGGTAGGGAAT", "GACATCGCACACC"}, // first longer
}

func TestHammingDistance(t *testing.T) {
	for _, test := range tests {
		actual := HammingDistance(test.strand1, test.strand2)
		if actual != test.expected {
			t.Errorf("HammingDistance(%s, %s): expected %d, actual %d", test.strand1, test.strand2, test.expected, actual)
		}
	}
}
