package three

import "testing"

func TestThree(t *testing.T) {
	if 3 != Tres.Value {
		t.Errorf("Expected Tres.Value to equal 3")
	}
}
