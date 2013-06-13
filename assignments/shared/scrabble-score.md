```ruby
Word.new("cabbage").score
# => 14
```

## Letter Values

```plain
Letter                           Value
A, E, I, O, U, L, N, R, S, T       1
D, G                               2
B, C, M, P                         3
F, H, V, W, Y                      4
K                                  5
J, X                               8
Q, Z                               10
```

Or represented as a ruby hash:

```ruby
{
  "a"=>1, "b"=>3, "c"=>3, "d"=>2, "e"=>1,
  "f"=>4, "g"=>2, "h"=>4, "i"=>1, "j"=>8,
  "k"=>5, "l"=>1, "m"=>3, "n"=>1, "o"=>1,
  "p"=>3, "q"=>10, "r"=>1, "s"=>1, "t"=>1,
  "u"=>1, "v"=>4, "w"=>4, "x"=>8, "y"=>4,
  "z"=>10
}
```

* You can play a `:double` or a `:triple` letter.
* You can play a `:double` or a `:triple` word.
