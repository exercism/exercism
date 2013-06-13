```ruby
beer = Beer.new

beer.verse(8)
# => "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n"
```

Not all verses are identical.

The verse for 1 bottle is as follows:

```ruby
beer.verse(1)
# => "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n"
```

The verse for 0 bottles is as follows:
```ruby
# => "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n"
```

You can get multiple verses by passing in the verse to start from, and (optionally) the last verse to include.

```ruby
beer.sing(8, 6)
# => "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n\n"

beer.sing(3)
# => sings verses for 3 bottles of beer, 2 bottles of beer, 1 bottle of beer, and no bottles of beer.
```

## Extensions

* Add a class method `Beer.song` which will return the entire song, starting at 99.
* Write a command line program that will print the entire song to the terminal
* Consider monkeypatching Fixnum so you could run `99.bottles_of_beer` or `12.bottles_of_beer` to run the song from an arbitrary starting point.
* Make it a bit more flexible, so `99.bottles_of_beer` works, but so does `99.bottles_of("seltzer")`
