package wc

import "testing"

func assertEqual(t *testing.T, actual Histogram, expected Histogram) {
	if !actual.Equal(expected) {
		t.Errorf("Expected %v to equal %v", actual, expected)
	}
}

func assertNotEqual(t *testing.T, h Histogram, other Histogram) {
	if h.Equal(other) || other.Equal(h) {
		t.Errorf("Expected %v to not equal %v", h, other)
	}
}

func TestEqual(t *testing.T) {
	h1 := Histogram{"hello": 1, "world": 2}
	h2 := Histogram{"hello": 1, "world": 2}
	assertEqual(t, h1, h2)
}

func TestNotEqual(t *testing.T) {
	t.SkipNow()
	h1 := Histogram{"word": 1}
	h2 := Histogram{"word": 1, "games": 2}
	assertNotEqual(t, h1, h2)
}

func TestCountOneWord(t *testing.T) {
	t.SkipNow()
	h := Histogram{"word": 1}
	assertEqual(t, WordCount("word"), h)
}

func TestCountOneOfEach(t *testing.T) {
	t.SkipNow()
	h := Histogram{"one": 1, "of": 1, "each": 1}
	assertEqual(t, WordCount("one of each"), h)
}

func TestCountMultipleOccurrences(t *testing.T) {
	t.SkipNow()
	actual := WordCount("one fish two fish red fish blue fish")
	expected := Histogram{"one": 1, "fish": 4, "two": 1, "red": 1, "blue": 1}
	assertEqual(t, actual, expected)
}

func TestIgnorePunctuation(t *testing.T) {
	t.SkipNow()
	actual := WordCount("car : carpet as java : javascript!!&@$%^&")
	expected := Histogram{"car": 1, "carpet": 1, "as": 1, "java": 1, "javascript": 1}
	assertEqual(t, actual, expected)
}

func TestIncludeNumbers(t *testing.T) {
	t.SkipNow()
	actual := WordCount("testing, 1, 2 testing")
	expected := Histogram{"testing": 2, "1": 1, "2": 1}
	assertEqual(t, actual, expected)
}

func TestNormalizeCase(t *testing.T) {
	t.SkipNow()
	assertEqual(t, WordCount("go Go GO"), Histogram{"go": 3})
}
