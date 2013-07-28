package rnatranscription

import "strings"

func ToRna(dna string) string {
	return strings.Replace(dna, "T", "U", -1)
}
