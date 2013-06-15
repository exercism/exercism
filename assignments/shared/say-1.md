In other words, if the input to the program is `22`, then the output should be `'twenty-two'`

e.g.

```ruby
Say.new(22).in_english
```

```ruby
Say.new(-1).in_english
# say.rb:7:in 'in_english': Number must be between 0 and 99, inclusive. (ArgumentError)
```

The program must also report any values that are out of range.

Some good test cases for this program are:

* 0
* 14
* 50
* 98
* -1
* 100

## Extensions

If you're on a Mac, shell out to Mac OS X's program to talk out loud.
