package one

import "testing"

func TestOne(t *testing.T) {
	if 1 != Uno.Value {
		t.Errorf("Expected Uno.Value to equal 1")
	}
}

