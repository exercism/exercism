package bob

import "strings"

func Hey(drivel string) string {
	if silent(drivel) {
		return "Fine. Be that way."
	}
	if yelling(drivel) {
		return "Woah, chill out!"
	}
	if asking(drivel) {
		return "Sure."
	}
	return "Whatever."
}

func yelling(drivel string) bool {
	return strings.ToUpper(drivel) == drivel
}

func asking(drivel string) bool {
	return strings.HasSuffix(drivel, "?")
}

func silent(drivel string) bool {
	return drivel == ""
}
