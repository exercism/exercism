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
	for k, _ := range h {
		if h[k] != o[k] {
			res = false
		}
	}
	return
}

func assertEqual(t *testing.T, in int, out int) {
	if in != out {
		t.Errorf("Got \"%v\", expected \"%v\"", out, in)
	}
}

type tallyTest struct {
	Strand    string
	Candidate string
	Expected  int
}

var tallyTests = []tallyTest{
	{"", "A", 0},
	{"CCCCC", "C", 5},
	{"GGGGGTAACCCGG", "T", 1},
}

func TestNucleotideCounts(t *testing.T) {
	for _, test := range tallyTests {
		dna := DNA{test.Strand}
		count, _ := dna.Count(test.Candidate)
		assertEqual(t, test.Expected, count)
	}
}

func TestHasErrorForInvalidNucleotides(t *testing.T) {
	dna := DNA{"GATTACA"}
	count, err := dna.Count("X")
	assertEqual(t, 0, count)
	if err == nil {
		t.Errorf("X is an invalid nucleotide, but no error was raised")
	}
}

// Not sure why this test is here as Count is a query method.
func TestCountingDoesntChangeCount(t *testing.T) {
	dna := DNA{"CGATTGGG"}
	dna.Count("T")
	count, _ := dna.Count("T")
	assertEqual(t, 2, count)
}

type histogramTest struct {
	Strand   string
	Expected Histogram
}

var histogramTests = []histogramTest{
	{
		Strand:   "",
		Expected: Histogram{"A": 0, "C": 0, "T": 0, "G": 0},
	},
	{
		Strand:   "GGGGGGGG",
		Expected: Histogram{"A": 0, "C": 0, "T": 0, "G": 8},
	},
	{
		Strand:   "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC",
		Expected: Histogram{"A": 20, "C": 12, "T": 21, "G": 17},
	},
}

func TestSequenceHistograms(t *testing.T) {
	for _, test := range histogramTests {
		dna := DNA{test.Strand}
		if !dna.Counts().Equal(test.Expected) {
			t.Errorf("DNA{ \"%v\" }: Got \"%v\", expected \"%v\"", test.Strand, dna.Counts(), test.Expected)
		}
	}
}
