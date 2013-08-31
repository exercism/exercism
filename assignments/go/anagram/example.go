package anagram

import "strings"

func Detect(subject string, candidates []string) []string {
	var matches []string
	for _, v := range candidates {
		if isAnagram(subject, v) {
			matches = append(matches, v)
		}
	}
	return matches
}

func isAnagram(subject, candidate string) bool {
	subject = strings.ToLower(subject)
	candidate = strings.ToLower(candidate)

	if subject == candidate {
		return false
	}

	if len(subject) != len(candidate) {
		return false
	}

	result := true
	for _, char := range subject {
		if strings.Count(subject, string(char)) == strings.Count(candidate, string(char)) {
			result = result && true
		} else {
			return false
		}
	}

	return result
}
