package anagram

import "testing"

func TestDetectNoAnagram(t *testing.T) {
	subject := "diaper"
	candidates := []string{"hello", "world", "zombies", "pants"}
	if matches := Detect(subject, candidates); matches != nil {
		t.Errorf("Expected empty slice, got %v.", matches)
	}
}

func TestDetectAnagram(t *testing.T) {
	subject := "listen"
	candidates := []string{"google", "inlets", "banana"}

	matches := Detect(subject, candidates)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "inlets" {
		t.Errorf("Expected inlets, got %v.", matches[0:])
	}
}

func TestAnagramsHaveSameLength(t *testing.T) {
	subject := "ant"
	candidates := []string{"tan", "stand"}

	matches := Detect(subject, candidates)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "tan" {
		t.Errorf("Expected tan, got %v.", matches[0:])
	}
}

func TestEliminateAnagramSubsets(t *testing.T) {
	subject := "good"
	candidates := []string{"dog", "goody"}
	if matches := Detect(subject, candidates); matches != nil {
		t.Errorf("Expected empty slice, got %v.", matches)
	}
}

func TestSubjectIsNotAnagram(t *testing.T) {
	subject := "banana"
	candidates := []string{"banana", "BANANA"}

	matches := Detect(subject, candidates)

	if matches != nil {
		t.Errorf("Expected empty slice, got %v.", matches)
	}
}

func TestImperfectAnagram(t *testing.T) {
	subject := "bladderless"
	candidates := []string{"breadseller"}

	matches := Detect(subject, candidates)

	if matches != nil {
		t.Errorf("Expected empty slice, got %v.", matches)
	}
}

func TestAnagramsAreCaseInsensitive(t *testing.T) {
	subject := "Orchestra"
	candidates := []string{"cashregister", "Carthorse", "radishes"}

	matches := Detect(subject, candidates)

	if len(matches) != 1 {
		t.Errorf("Expected 1 element, got %d.", len(matches))
	}

	if matches[0] != "Carthorse" {
		t.Errorf("Expected Carthorse, got %v.", matches[0:])
	}
}
