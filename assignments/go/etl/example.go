package etl

import "strings"

func Transform(input map[int][]string) (out map[string]int) {
	out = make(map[string]int)
	for key, values := range input {
		for _, val := range values {
			out[strings.ToLower(val)] = key
		}
	}
	return
}
