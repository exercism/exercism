package romannumerals

import (
	"bytes"
)

type arabicToRoman struct {
	arabic int
	roman  string
}

func ToRomanNumeral(input int) string {
	buffer := bytes.NewBufferString("")

	mappings := []arabicToRoman{
		arabicToRoman{1000, "M"},
		arabicToRoman{900, "CM"},
		arabicToRoman{500, "D"},
		arabicToRoman{400, "CD"},
		arabicToRoman{100, "C"},
		arabicToRoman{90, "XC"},
		arabicToRoman{50, "L"},
		arabicToRoman{40, "XL"},
		arabicToRoman{10, "X"},
		arabicToRoman{9, "IX"},
		arabicToRoman{5, "V"},
		arabicToRoman{4, "IV"},
		arabicToRoman{1, "I"},
	}

	for _, m := range mappings {
		for input >= m.arabic {
			buffer.WriteString(m.roman)
			input -= m.arabic
		}
	}

	return buffer.String()
}
