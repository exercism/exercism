When we need to represent sorted data, an array does not make a good data structure.

Say we have the array `[1, 3, 4, 5]`, and we add 2 to it so it becomes `[1, 3, 4, 5, 2]` now we must sort the entire array again! We can improve on this by realizing that we only need to make space for the new item `[1, nil, 3, 4, 5]`, and then adding the item in the space we added. But this still requires us to shift many elements down by one.

Binary Search Trees, however, can operate on sorted data much more efficiently.

A binary search tree consists of a series of connected nodes. Each node contains a piece of data (e.g. the number 3), a variable named `left`, and a variable named `right`. The `left` and `right` variables point at `nil`, or other nodes. Since these other nodes in turn have other nodes beneath them, we say that the left and right variables are pointing at subtrees. All data in the left subtree is less than or equal to the current node's data, and all data in the right subtree is greater than the current node's data.

For example, if we had a node containing the data 4, and we added the data 2, our tree would look like this:

      4
     /
    2

If we then added 6, it would look like this:

      4
     / \
    2   6

If we then added 3, it would look like this

       4
     /   \
    2     6
     \
      3

And if we then added 1, 5, and 7, it would look like this

          4
        /   \
       /     \
      2       6
     / \     / \
    1   3   5   7
