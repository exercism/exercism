package romannumerals

import (
	"testing"
)

type romanNumeralTest struct {
	arabic int
	roman  string
}

var romanNumeralTests = []romanNumeralTest{
	{1, "I"},
	{2, "II"},
	{3, "III"},
	{4, "IV"},
	{5, "V"},
	{6, "VI"},
	{9, "IX"},
	{27, "XXVII"},
	{48, "XLVIII"},
	{59, "LIX"},
	{93, "XCIII"},
	{141, "CXLI"},
	{163, "CLXIII"},
	{402, "CDII"},
	{575, "DLXXV"},
	{911, "CMXI"},
	{1024, "MXXIV"},
	{3000, "MMM"},
}

func TestRomanNumerals(t *testing.T) {
	for _, test := range romanNumeralTests {
		actual := ToRomanNumeral(test.arabic)
		if actual != test.roman {
			t.Errorf("ToRomanNumeral(%d): expected %s, actual %s", test.arabic, test.roman, actual)
		}
	}
}
