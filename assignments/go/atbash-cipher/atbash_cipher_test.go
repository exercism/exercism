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
	{"gvhgr mt123 gvhgr mt", "Testing, 1 2 3, testing."},
	{"gifgs rhurx grlm", "Truth is fiction."},
	{"gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt", "The quick brown fox jumps over the lazy dog."},
}

func TestAtbash(t *testing.T) {
	for _, test := range tests {
		actual := Atbash(test.s)
		if actual != test.expected {
			t.Errorf("Atbash(%s): expected %s, actual %s", test.s, test.expected, actual)
		}
	}
}

func BenchmarkAtbash(b *testing.B) {
	b.StopTimer()
	for _, test := range tests {
		b.StartTimer()

		for i := 0; i < b.N; i++ {
			Atbash(test.s)
		}

		b.StopTimer()
	}
}
