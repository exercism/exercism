# Binary Search Trees

A binary search tree is used to store sorted data for more efficient inserting
and lookups.

A simple binary search tree might look like this:

```ruby
tree = Bst.new(4)
tree.insert(6)
tree.insert(2)
tree.insert(3)
tree.insert(7)
tree.insert(5)
tree.insert(1)
```

          4
        /   \
       /     \
      2       6
     / \     / \
    1   3   5   7


If we then wanted to iterate over it, we would want to first iterate over all the smaller data, then the current data,
then the larger data. So for this tree, we would first go down 4's left subtree to 2, then the left subtree to 1.
There is no left subtree from 1 (no smaller data), so we would yield 1 and
return to 2, and yield 2.
Then down 2's right subtree to 3, which has no left node, so we would yield 3 and return to 2.
Now 2 is done, so return to 4. Since we've iterated over all of 4's left subtree, there is no smaller data,
so we would yield 4, and then go down its right subtree to 6, then 5 which we would yield.
Then back up to 6, yield 6, down to 7, yield 7. Back to 6 which is done, so back up to 4,
which is now done as well, and we have iterated over the entire tree!

The path would look like this:

* 4
* 2
* 1 (yield)
* 2 (yield)
* 3 (yield)
* 2
* 4 (yield)
* 6
* 5 (yield)
* 6 (yield)
* 7 (yield)
* 6
* 4

Your job is to make a binary search tree and allow it to be iterated over.

**hint** You can receive a block as a parameter like this `def each(&block)`,
you can yield data to it like this `block.call(100)`,
you can pass it as a block to another method like this `some_object.some_method(&block)`

## Source
Josh Cheek

