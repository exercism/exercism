package anagram

import "testing"

func TestDetectNoAnagram(t *testing.T) {
	in := "diaper"
	possibleMatches := []string{"hello", "world", "zombies", "pants"}
	if matches := Detect(in, possibleMatches); matches != nil {
		t.Errorf("Expected empty slice, got %v.", matches)
	}
}

func TestDetectAnagram(t *testing.T) {
	in := "listen"
	possibleMatches := []string{"google", "inlets", "banana"}

	matches := Detect(in, possibleMatches)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "inlets" {
		t.Errorf("Expected inlets, got %v.", matches[0:])
	}
}

func TestAnagramsHaveSameLength(t *testing.T) {
	in := "ab"
	possibleMatches := []string{"ba", "abc"}

	matches := Detect(in, possibleMatches)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "ba" {
		t.Errorf("Expected ba, got %v.", matches[0:])
	}
}
