package binary_search_tree

type SearchTreeData struct {
	left *SearchTreeData
	data int
	right *SearchTreeData
}

func Bst(i int) SearchTreeData {
	return SearchTreeData{data: 4}
}

func (std *SearchTreeData) Insert(i int) {
	if i <= std.data {
		if std.left != nil {
			std.left.Insert(i)
		} else {
			std.left = &SearchTreeData{data: i}
		}
	} else {
		if std.right != nil {
			std.right.Insert(i)
		} else {
			std.right = &SearchTreeData{data: i}
		}
	}
}

type stringCallback func(int) string

func (std *SearchTreeData) MapString(f stringCallback) (result []string) {
	if std.left != nil {
		result = append(std.left.MapString(f), result...)
	}
	result = append(result, []string{f(std.data)}...)
	if std.right != nil {
		result = append(result, std.right.MapString(f)...)
	}
	return result
}

type intCallback func(int) int

func (std *SearchTreeData) MapInt(f intCallback) (result []int) {
	if std.left != nil {
		result = append(std.left.MapInt(f), result...)
	}
	result = append(result, []int{f(std.data)}...)
	if std.right != nil {
		result = append(result, std.right.MapInt(f)...)
	}
	return result
}
