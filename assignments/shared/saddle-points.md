```plain
    0  1  2
  |---------
0 | 9  8  7
1 | 5  3  2     <--- saddle point at (1,0)
2 | 6  6  7
```


```ruby
matrix = Matrix.new("9 8 7\n5 3 2\n6 6 7")
matrix.saddle_points
# => [[1, 0]]
```

```plain
  0  1  2
  |---------
0 | 4  5  4
1 | 3  5  5     <--- saddle point at (1,0)
2 | 1  5  4
```

A matrix may have zero saddle points, or it might have several.
