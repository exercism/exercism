package octal

import (
	"strconv"
)

func ToDecimal(input string) (r int64) {
	r, _ = strconv.ParseInt(input, 8, 0)
	return
}
