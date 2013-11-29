package allergies

import "math"

var allergens = []string{ "eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats" }

func Allergies(i int) (result []string) {
	for _, v := range allergens {
		if AllergicTo(i, v) {
			result = append(result, []string{v}...)
		}
	}
	return result
}

func AllergicTo(i int, allergen string) bool {
	index := indexOf(allergens, allergen)
	x := int(math.Pow(2.0, float64(index)))
	return (i & x) > 0
}

func indexOf(slice []string, string string) int {
	for p, v := range slice {
		if (v == string) {
			return p
		}
	}
	return -1
}
