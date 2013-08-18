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
	in := "ant"
	possibleMatches := []string{"tan", "stand"}

	matches := Detect(in, possibleMatches)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "tan" {
		t.Errorf("Expected tan, got %v.", matches[0:])
	}
}

func TestEliminateAnagramSubsets(t *testing.T) {
	in := "good"
	possibleMatches := []string{"dog", "goody"}
	if matches := Detect(in, possibleMatches); matches != nil {
		t.Errorf("Expected empty slice, got %v.", matches)
	}
}

func TestAnagramsAreCaseInsensitive(t *testing.T) {
	in := "Orchestra"
	possibleMatches := []string{"cashregister", "Carthorse", "radishes"}

	matches := Detect(in, possibleMatches)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "Carthorse" {
		t.Errorf("Expected Carthorse, got %v.", matches[0:])
	}
}
