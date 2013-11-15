package binary

import "strconv"

func ToDecimal(s string) int {
	n, _ := strconv.ParseInt(s, 2, 64)
	return int(n)
}
