## `Array#keep`

Implement an instance method on Array called `keep` which lets you
evaluate each element in the array and returns a new array with
only the elements where the evaluation is truthy.

## `Array#discard`

Implement an instance method on Array called `keep` which lets you
evaluate each element in the array and returns a new array with
only the elements where the evaluation is falsy.

## Examples

```ruby
numbers = [1, 2, 3, 4, 5]
evens = numbers.keep do |number|
  number.even?
end

odds = numbers.discard do |number|
  number.even?
end
```

## Restrictions

You may only use Enumerable#each to implement this method. No other enumerable methods are allowed.
