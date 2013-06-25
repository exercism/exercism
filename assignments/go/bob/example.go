package bob

import "strings"

func Hey(drivel string) (reply string) {
	reply = "Whatever."
	if silent(drivel) {
		reply = "Fine. Be that way."
	}
	if yelling(drivel) {
		reply = "Woah, chill out!"
	}
	if asking(drivel) {
		reply = "Sure."
	}
	return
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
