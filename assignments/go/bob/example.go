package bob

import "strings"

func Hey(drivel string) string {
	switch {
	case silent(drivel):
		return "Fine. Be that way!"
	case yelling(drivel):
		return "Woah, chill out!"
	case asking(drivel):
		return "Sure."
	default:
		return "Whatever."
	}
}

func yelling(drivel string) bool {
	return strings.ToUpper(drivel) == drivel && strings.ToLower(drivel) != strings.ToUpper(drivel)
}

func asking(drivel string) bool {
	return strings.HasSuffix(drivel, "?")
}

func silent(drivel string) bool {
	return strings.Trim(drivel, " ") == ""
}
