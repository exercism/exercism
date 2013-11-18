package octal

import (
	"math"
	"strconv"
	"strings"
)

// Easy way:
// r, _ = strconv.ParseInt(input, 8, 0)
//
// Let's do it the hard way.

func ToDecimal(s string) (r int64) {
	digits := strings.Split(s, "")
	length := len(digits)

	for i := length; i > 0; i = i - 1 {
		v, _ := strconv.ParseInt(digits[i-1], 10, 0)
		r = r + (v * int64(math.Pow(8, float64(length-i))))
	}
	return r
}
