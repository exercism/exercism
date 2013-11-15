package wc

import (
	"regexp"
	"strings"
)

type Histogram map[string]int

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

func WordCount(phrase string) Histogram {
	counts := make(Histogram)
	for _, word := range strings.Fields(normalize(phrase)) {
		counts[word]++
	}
	return counts
}

func normalize(phrase string) string {
	r, _ := regexp.Compile(`[^\w]`)
	phrase = strings.ToLower(phrase)
	return r.ReplaceAllLiteralString(phrase, " ")
}
