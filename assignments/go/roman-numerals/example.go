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
		{1000, "M"},
		{900, "CM"},
		{500, "D"},
		{400, "CD"},
		{100, "C"},
		{90, "XC"},
		{50, "L"},
		{40, "XL"},
		{10, "X"},
		{9, "IX"},
		{5, "V"},
		{4, "IV"},
		{1, "I"},
	}

	for _, m := range mappings {
		for input >= m.arabic {
			buffer.WriteString(m.roman)
			input -= m.arabic
		}
	}

	return buffer.String()
}
