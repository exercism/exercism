package atbash

import "testing"

var tests = []struct {
	expected string
	s        string
}{
	{"ml", "no"},
	{"ml", "no"},
	{"bvh", "yes"},
	{"lnt", "OMG"},
	{"lnt", "O M G"},
	{"nrmwy oldrm tob", "mindblowingly"},
//	{"gvhgr mt123 gvhgr mt", "Testing, 1 2 3, testing."},
//	{"gifgs rhurx grlm", "Truth is fiction."},
//	{"The quick brown fox jumps over the lazy dog.", "gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt"},
}

func TestAtbash(t *testing.T) {
	for _, test := range tests {
		actual := Atbash(test.s)
		if actual != test.expected {
			t.Errorf("Atbash(%s): expected %s, actual %s", test.s, test.expected, actual)
		}
	}
}
