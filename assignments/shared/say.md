## Step 1

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

## Step 2

```ruby
Chunks.new(1234567890).split
# => [1, 234, 567, 890]

Chunks.new(1000).split
# => [0, 0, 1, 0]
```

The program must also report any values that are out of range.

## Step 3

In other words, if the input to the program is `1234567890` then the output should be `'1 billion 234 million 567 thousand 890'`

The program must also report any values that are out of range.


## Step 4

In other words, if the input to the program is `12345` then the output should be `twelve thousand three hundred forty-five`.

The program must also report any values that are out of range.

## Extensions

Use _and_ (correctly) in the English number:

* fourteen
* one hundred
* one hundred and twenty
* one thousand and two
* one thousand three hundred and twenty-three
