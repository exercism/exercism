package anagram

import (
	"sort"
	"testing"
)

var testCases = []struct {
	subject     string
	candidates  []string
	expected    []string
	description string
}{
	{
		subject: "diaper",
		candidates: []string{
			"hello",
			"world",
			"zombies",
			"pants",
		},
		expected:    []string{},
		description: "no matches",
	},
	{
		subject: "ant",
		candidates: []string{
			"tan",
			"stand",
			"at",
		},
		expected:    []string{"tan"},
		description: "simple anagram",
	},
	{
		subject: "listen",
		candidates: []string{
			"enlists",
			"google",
			"inlets",
			"banana",
		},
		expected:    []string{"inlets"},
		description: "another simple anagram",
	},
	{
		subject: "master",
		candidates: []string{
			"stream",
			"pigeon",
			"maters",
		},
		expected:    []string{"maters", "stream"},
		description: "multiple anagrams",
	},
	{
		subject: "allergy",
		candidates: []string{
			"gallery",
			"ballerina",
			"regally",
			"clergy",
			"largely",
			"leading",
		},
		expected:    []string{"gallery", "largely", "regally"},
		description: "multiple anagrams (again)",
	},
	{
		subject: "galea",
		candidates: []string{
			"eagle",
		},
		expected:    []string{},
		description: "does not confuse different duplicates",
	},
	{
		subject: "corn",
		candidates: []string{
			"corn",
			"dark",
			"Corn",
			"rank",
			"CORN",
			"cron",
			"park",
		},
		expected:    []string{"cron"},
		description: "identical word is not anagram",
	},
	{
		subject: "mass",
		candidates: []string{
			"last",
		},
		expected:    []string{},
		description: "eliminate anagrams with same checksum",
	},
	{
		subject: "good",
		candidates: []string{
			"dog",
			"goody",
		},
		expected:    []string{},
		description: "eliminate anagram subsets",
	},
	{
		subject: "Orchestra",
		candidates: []string{
			"cashregiser",
			"carthorse",
			"radishes",
		},
		expected:    []string{"carthorse"},
		description: "subjects are case insensitive",
	},
	{
		subject: "orchestra",
		candidates: []string{
			"cashregiser",
			"Carthorse",
			"radishes",
		},
		expected:    []string{"carthorse"},
		description: "candidates are case insensitive",
	},
}

func equal(a []string, b []string) bool {
	if len(b) != len(a) {
		return false
	}

	sort.Strings(a)
	sort.Strings(b)
	for i := 0; i < len(a); i = i + 1 {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}

func TestDetectAnagrams(t *testing.T) {
	for _, tt := range testCases {
		actual := Detect(tt.subject, tt.candidates)
		if !equal(tt.expected, actual) {
			msg := `
				%s

				Given %v
				Candidates %v
				Expected %v
				Got %v
				`
			t.Fatalf(msg, tt.description, tt.expected, actual)
		}
	}
}
