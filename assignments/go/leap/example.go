package leap

func IsLeap(year int) bool {
	isVanilla := (year % 4) == 0
	isCentury := (year % 100) == 0
	isException := (year % 400) == 0
	return isVanilla && !isCentury || isException
}
