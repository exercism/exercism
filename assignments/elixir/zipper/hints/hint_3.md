```elixir
@type trail :: { :left, any, BinTree.t, trail }
             | { :right, any, BinTree.t, trail }
             | :top
```

or

```elixir
@type trail :: [ { :left, any, BinTree.t } | { :right, any, BinTree.t } ]
```

The immediate parent should be the easiest to access.

A zipper record contains the node's value, left branch, right branch and the
trail.
