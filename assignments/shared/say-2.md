```ruby
Chunks.new(1234567890).split
# => [1, 234, 567, 890]

Chunks.new(1000).split
# => [0, 0, 1, 0]
```

The program must also report any values that are out of range.
