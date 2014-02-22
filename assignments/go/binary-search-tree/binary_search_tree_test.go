package binary_search_tree

import (
	"testing"
	"fmt"
)

func TestDataIsRetained(t *testing.T) {
	expected := 4
	actual := Bst(4).data
	if expected != actual {
		t.Errorf("Bst(4).data: expected %d, actual %d", expected, actual)
	}
}

func TestInsertingLess(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(2)

	expected_data := 4
	actual_data := bst.data
	if expected_data != actual_data {
		t.Errorf("bst.data: expected %d, actual %d", expected_data, actual_data)
	}

	expected_left_data := 2
	actual_left_data := bst.left.data
	if expected_left_data != actual_left_data {
		t.Errorf("bst.data: expected %d, actual %d", expected_left_data, actual_left_data)
	}
}

func TestInsertingSame(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(4)

	expected_data := 4
	actual_data := bst.data
	if expected_data != actual_data {
		t.Errorf("bst.data: expected %d, actual %d", expected_data, actual_data)
	}

	expected_left_data := 4
	actual_left_data := bst.left.data
	if expected_left_data != actual_left_data {
		t.Errorf("bst.data: expected %d, actual %d", expected_left_data, actual_left_data)
	}
}

func TestInsertingMore(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(5)

	expected_data := 4
	actual_data := bst.data
	if expected_data != actual_data {
		t.Errorf("bst.data: expected %d, actual %d", expected_data, actual_data)
	}

	expected_right_data := 5
	actual_left_data := bst.right.data
	if expected_right_data != actual_left_data {
		t.Errorf("bst.data: expected %d, actual %d", expected_right_data, actual_left_data)
	}
}

func TestComplexTree(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(2)
	bst.Insert(6)
	bst.Insert(1)
	bst.Insert(3)
	bst.Insert(7)
	bst.Insert(5)

	expected := 4
	actual := bst.data
	if actual != expected {
		t.Errorf("bst.data: expected %d, actual %d", expected, actual)
	}

	expected = 2
	actual = bst.left.data
	if actual != expected {
		t.Errorf("bst.left.data: expected %d, actual %d", expected, actual)
	}

	expected = 1
	actual = bst.left.left.data
	if actual != expected {
		t.Errorf("bst.left.left.data: expected %d, actual %d", expected, actual)
	}

	expected = 3
	actual = bst.left.right.data
	if actual != expected {
		t.Errorf("bst.left.right.data: expected %d, actual %d", expected, actual)
	}

	expected = 6
	actual = bst.right.data
	if actual != expected {
		t.Errorf("bst.right.data: expected %d, actual %d", expected, actual)
	}

	expected = 5
	actual = bst.right.left.data
	if actual != expected {
		t.Errorf("bst.right.left.data: expected %d, actual %d", expected, actual)
	}

	expected = 7
	actual = bst.right.right.data
	if actual != expected {
		t.Errorf("bstfour.right.right.data: expected %d, actual %d", expected, actual)
	}
}

func iToS(i int) string {
	return fmt.Sprintf("%d", i)
}

func TestMapStringWithOneElement(t *testing.T) {
	bst := SearchTreeData{data: 4}

	expected := []string{"4"}
	actual := bst.MapString(iToS)
	if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", expected) {
		t.Errorf("bst.MapString(): expected %s, actual %s", expected, actual)
	}
}

func TestMapStringWithSmallElement(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(2)

	expected := []string{"2", "4"}
	actual := bst.MapString(iToS)
	if fmt.Sprintf("%v", actual) != fmt.Sprintf("%v", expected) {
		t.Errorf("bst.MapString(): expected %v, actual %v", expected, actual)
	}
}

func TestMapStringWithLargeElement(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(5)

	expected := []string{"4", "5"}
	actual := bst.MapString(iToS)
	if fmt.Sprintf("%v", actual) != fmt.Sprintf("%v", expected) {
		t.Errorf("bst.MapString(): expected %v, actual %v", expected, actual)
	}
}

func TestMapStringWithComplexStructure(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(2)
	bst.Insert(1)
	bst.Insert(3)
	bst.Insert(6)
	bst.Insert(7)
	bst.Insert(5)

	expected := []string{"1", "2", "3", "4", "5", "6", "7"}
	actual := bst.MapString(iToS)
	if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", expected) {
		t.Errorf("bst.MapString(): expected %s, actual %s", expected, actual)
	}
}

func TestMapIntWithComplexStructure(t *testing.T) {
	bst := SearchTreeData{data: 4}
	bst.Insert(2)
	bst.Insert(1)
	bst.Insert(3)
	bst.Insert(6)
	bst.Insert(7)
	bst.Insert(5)

	f := func(i int) int {
		return i
	}

	expected := []int{1, 2, 3, 4, 5, 6, 7}
	actual := bst.MapInt(f)
	if fmt.Sprintf("%s", actual) != fmt.Sprintf("%s", expected) {
		t.Errorf("bst.MapInt(): expected %s, actual %s", expected, actual)
	}
}
