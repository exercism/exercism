```ruby
numbers = [1, 2, 3, 4, 5]
squares = numbers.accumulate do |number|
  number * number
end
```

## Restrictions

You may only use Enumerable#each to implement this method. No other enumerable methods are allowed.
