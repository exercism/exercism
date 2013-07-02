package anagram

import "strings"

func Detect(word string, possibleMatches []string) ([]string){
	var matches []string
	for _, v := range possibleMatches {
		if isAnagram(word, v) {
			matches = append(matches, v)
		}
	}
	return matches
}

func isAnagram(word, wordToMatch string) bool {
	if len(word) != len(wordToMatch) {
		return false
	}

	result := true
	for _, char := range word {
		if strings.Contains(wordToMatch, string(char)){
			result = result && true
		} else {
			return false
		}
	}

	return result
}
