package dna

import (
	"errors"
	"strings"
)

type Histogram map[string]int

type DNA struct {
	Strand string
}

func (dna DNA) Count(nucleotide string) (count int, err error) {
	found := false
	for _, nc := range []string{"A", "C", "G", "T", "U"} {
		if nucleotide == nc {
			found = true
		}
	}
	if found {
		count = strings.Count(dna.Strand, nucleotide)
	} else {
		err = errors.New("dna: invalid nucleotide " + nucleotide)
	}
	return
}

func (dna DNA) Counts() Histogram {
	a, _ := dna.Count("A")
	c, _ := dna.Count("C")
	t, _ := dna.Count("T")
	g, _ := dna.Count("G")

	return Histogram{"A": a, "C": c, "T": t, "G": g}
}
