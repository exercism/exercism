The tricky thing here is that a leap year occurs when at least one of the
following is true:

```plain
year is evenly divisible by 4
year is evenly divisible by 400 AND NOT evenly divisible by 100
```

Otherwise, not a leap year.

For example, 1997 is not a leap year, but 1996 is.
1900 is not a leap year, but 2000 is.

If your language provides a method in the standard library that does this
look-up, pretend it doesn't exist and implement it yourself.

## Notes

For a delightful, four minute explanation of the whole leap year phenomenon, go watch [this youtube video](http://www.youtube.com/watch?v=xX96xng7sAE).
