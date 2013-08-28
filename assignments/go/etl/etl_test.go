package etl

import "testing"

var transformTests = []struct {
	input    map[int][]string
	expected map[string]int
}{
	{
		map[int][]string{1: []string{"WORLD"}},
		map[string]int{"world": 1},
	},
  {
    map[int][]string{1: []string{"WORLD", "GSCHOOLERS"}},
    map[string]int{"world": 1, "gschoolers": 1},
  },
  {
    map[int][]string{
      1: []string{"APPLE", "ARTICHOKE"},
      2: []string{"BOAT", "BALLERINA"},
      },
    map[string]int{
      "apple": 1, 
      "artichoke": 1,
      "boat": 2, 
      "ballerina": 2,
      },
  },
  {
    map[int][]string{
      1: []string{"A", "E", "I", "O", "U", "L", "N", "R", "S", "T"},
      2: []string{"D", "G"},
      3: []string{"B", "C", "M", "P"},
      4: []string{"F", "H", "V", "W", "Y"},
      5: []string{"K"},
      8: []string{"J", "X"},
      10: []string{"Q", "Z"},
      },
    map[string]int{
      "a": 1, "e": 1, "i": 1, "o": 1, "u": 1, "l": 1, "n": 1, "r": 1, "s": 1, "t": 1, 
      "d": 2, "g": 2,
      "b": 3, "c": 3, "m": 3, "p": 3,
      "f": 4, "h": 4, "v": 4, "w": 4, "y": 4,
      "k": 5,
      "j": 8, "x": 8,
      "q": 10, "z": 10,
      },
  },
}

func mapsMatch(actual map[string]int, expected map[string]int) bool{
  if len(actual) != len(expected) {
    return false
  }

  for k, actualVal := range actual{
    expectedVal, present := expected[k]

    if !present || actualVal != expectedVal{
      return false
    }
  }

  return true
}

func TestTranform(t *testing.T) {
	for _, test := range transformTests {
		actual := Transform(test.input)
		if !mapsMatch(actual, test.expected) {
			t.Errorf("Transform(%v). Expected [%v], Actual [%v]", test.input, test.expected, actual)
		}
	}
}
