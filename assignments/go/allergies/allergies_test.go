package allergies

import(
	"fmt"
	"testing"
)

var allergiesTests = []struct {
	expected []string
	input int
}{
	{[]string{}, 0},
	{[]string{"eggs"}, 1},
	{[]string{"peanuts"}, 2},
	{[]string{"strawberries"}, 8},
	{[]string{"eggs", "peanuts"}, 3},
	{[]string{"eggs", "shellfish"}, 5},
	{[]string{"strawberries", "tomatoes", "chocolate", "pollen", "cats"}, 248},
	{[]string{"eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"}, 255},
	{[]string{"eggs", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"}, 509},
}

func TestAllergies(t *testing.T) {
	for _, test := range allergiesTests {
		actual := Allergies(test.input)
		if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", test.expected)  {
			t.Errorf("Allergies(%d): expected %s, actual %s", test.input, test.expected, actual)
		}
	}
}

var allergicToTests = []struct {
	expected bool
	i int
	allergen string
}{
	{false, 0, "peanuts"},
	{false, 0, "cats"},
	{false, 0, "strawberries"},
	{true, 1, "eggs"},
	{true, 5, "eggs"},
}

func TestAllergicTo(t *testing.T) {
	for _, test := range allergicToTests {
		actual := AllergicTo(test.i, test.allergen)
		if actual != test.expected  {
			t.Errorf("AllergicTo(%s, %s): expected %s, actual %s", test.i, test.allergen, test.expected, actual)
		}
	}
}
