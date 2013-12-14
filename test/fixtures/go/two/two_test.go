package two

import "testing"

func TestTwo(t *testing.T) {
	if 2 != Due.Value {
		t.Errorf("Expected Due.Value to equal 2")
	}
}
