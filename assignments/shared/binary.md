You may not use built-in ruby libraries or gems to accomplish the conversion.

The program should consider strings specifying an invalid binary as the value 0.

This is how computers work:

```bash
# "1011001"
  1     0     1     1     0     0     1
2^6 + 2^5 + 2^4 + 2^3 + 2^2 + 2^1 + 2^0
 64 +   0 +  16 +   8 +   0 +   0 +   1 = 89
```

If you want to write extra tests and/or check your answers, feel free to use irb:

```ruby
irb(main):001:0> 0b1011001
=> 89
irb(main):002:0> 0b1101
=> 13
irb(main):003:0> 0b110110110110101
=> 28085
```
