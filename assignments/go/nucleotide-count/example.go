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
	validNucleotides := "ACGTU"
	if (!strings.Contains(validNucleotides, nucleotide)) {
		return 0, errors.New("dna: invalid nucleotide " + nucleotide)
	}

	return strings.Count(dna.Strand, nucleotide), nil
}

func (dna DNA) Counts() Histogram {
	a, _ := dna.Count("A")
	c, _ := dna.Count("C")
	t, _ := dna.Count("T")
	g, _ := dna.Count("G")

	return Histogram{"A": a, "C": c, "T": t, "G": g}
}
