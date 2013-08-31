So say you've a matrix like so:

```plain
    0  1  2
  |---------
0 | 9  8  7
1 | 5  3  2     <--- saddle point at (1,0)
2 | 6  6  7
```

It's got a saddle point at (1, 0).

It's called a "saddle point"
because its neighbors on one axis are bigger than it
while its neighbors along the other are smaller.

A matrix may have zero saddle points, or it might have several.

Your code should be able to provide the (possibly empty) list of all the saddle
points for any given matrix.
