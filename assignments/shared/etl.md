This is a fancy way of saying "We have some crufty, legacy data over in this
system, and now we need it in this shiny new system over here, so we're going
to migrate this".

Typically, this is followed by "We're only going to need to run this once",
which is then typically followed by much forehead slapping and moaning about
how stupid we could possibly be.

We're going to extract some scrabble scores from a legacy system which gives
us the following data structure:

```ruby
{
  1 => %W(A E I O U L N R S T),
  2 => %W(D G),
  3 => %W(B C M P),
  4 => %W(F H V W Y),
  5 => %W(K),
  8 => %W(J X),
  10 => %W(Q Z),
}
```

The shiny new scrabble system needs the data in the following format:

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

Your mission, should you choose to accept it, is to write a program that
transforms the legacy data format to the shiny new format.
