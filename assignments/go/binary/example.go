package binary

import "math"

func ToDecimal(numString string) (result int) {
	endIndex := len(numString) - 1
	for i := endIndex; i >= 0; i-- {
		digit := string(numString[i])
		if validDigit(digit) {
			if digit == "1" {
				result += calcDigitValue(i, endIndex)
			}
		} else {
			return 0
		}

	}
	return
}

func calcDigitValue(position, length int) (result int) {
	if position == length {
		result = 1
	} else {
		result = int(math.Pow(2, float64(length-position)))
	}
	return
}

func validDigit(digit string) bool {
	return digit == "1" || digit == "0"
}
