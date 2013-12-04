package octal

import (
	"math"
	"strconv"
)

// Easy way:
// r, _ = strconv.ParseInt(input, 8, 0)
//
// Let's do it the hard way.

func ToDecimal(s string) (n int64) {
	length := len(s)

	for i := length; i > 0; i-- {
		v, _ := strconv.ParseInt(string(s[i-1]), 10, 0)
		n = n + (v * int64(math.Pow(8, float64(length-i))))
	}
	return n
}
