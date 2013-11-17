package dna

import "testing"

func (h Histogram) Equal(o Histogram) bool {
	return h.sameLength(o) && h.sameMappings(o)
}

func (h Histogram) sameLength(o Histogram) bool {
	return len(h) == len(o)
}

func (h Histogram) sameMappings(o Histogram) (res bool) {
	res = true
	for k := range h {
		if h[k] != o[k] {
			res = false
		}
	}
	return
}

var tallyTests = []struct {
	strand     string
	nucleotide string
	expected   int
}{
	{"", "A", 0},
	{"ACT", "G", 0},
	{"CCCCC", "C", 5},
	{"GGGGGTAACCCGG", "T", 1},
}

func TestNucleotideCounts(t *testing.T) {
	for _, tt := range tallyTests {
		dna := DNA{tt.strand}
		count, _ := dna.Count(tt.nucleotide)
		if count != tt.expected {
			t.Fatalf("Got \"%v\", expected \"%v\"", count, tt.expected)
		}
	}
}

func TestHasErrorForInvalidNucleotides(t *testing.T) {
	dna := DNA{"GATTACA"}
	count, err := dna.Count("X")
	if count != 0 {
		t.Fatalf("Got \"%v\", expected \"%v\"", count, 0)
	}
	if err == nil {
		t.Fatalf("X is an invalid nucleotide, but no error was raised")
	}
}

// In most cases, this test is pointless.
// Very occasionally it matters.
// Just roll with it.
func TestCountingDoesntChangeCount(t *testing.T) {
	dna := DNA{"CGATTGGG"}
	dna.Count("T")
	count, _ := dna.Count("T")
	if count != 2 {
		t.Fatalf("Got \"%v\", expected \"%v\"", count, 2)
	}
}

type histogramTest struct {
	strand   string
	expected Histogram
}

var histogramTests = []histogramTest{
	{
		"",
		Histogram{"A": 0, "C": 0, "T": 0, "G": 0},
	},
	{
		"GGGGGGGG",
		Histogram{"A": 0, "C": 0, "T": 0, "G": 8},
	},
	{
		"AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC",
		Histogram{"A": 20, "C": 12, "T": 21, "G": 17},
	},
}

func TestSequenceHistograms(t *testing.T) {
	for _, tt := range histogramTests {
		dna := DNA{tt.strand}
		if !dna.Counts().Equal(tt.expected) {
			t.Fatalf("DNA{ \"%v\" }: Got \"%v\", expected \"%v\"", tt.strand, dna.Counts(), tt.expected)
		}
	}
}
