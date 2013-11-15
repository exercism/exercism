package bob

import "strings"

func Hey(drivel string) string {
	switch {
	case silent(drivel):
		return "Fine. Be that way!"
	case asking(drivel):
		return "Sure."
	case yelling(drivel):
		return "Woah, chill out!"
	default:
		return "Whatever."
	}
}

func yelling(drivel string) bool {
	return len(drivel) > 0 && strings.ToUpper(drivel) == drivel
}

func asking(drivel string) bool {
	return strings.HasSuffix(drivel, "?")
}

func silent(drivel string) bool {
	return drivel == ""
}
