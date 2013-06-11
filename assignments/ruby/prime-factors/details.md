A prime number is only evenly divisible by itself and 1.

Note that 1 is not a prime number.

## Example

What are the prime factors of 60?

Our first divisor is 2.

```ruby
number = 60
factors = []
```

2 goes into 60, leaving 30.

```ruby
number = 30
factors = [2]
```

2 goes into 30, leaving 15.

```ruby
number = 15
factors = [2, 2]
```

2 doesn't go cleanly into 15.

So let's move on to our next divisor, 3.

3 goes cleanly into 15, leaving 5.

```ruby
number = 5
factors = [2, 2, 3]
```

3 does not go cleanly into 5. The next possible factor is 4.

4 does not go cleanly into 5. The next possible factor is 5.

5 does go cleanly into 5.

```ruby
number = 1
factors = [2, 2, 3, 5]
```

Now that our number is 1, we're done.
