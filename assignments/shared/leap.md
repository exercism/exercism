The tricky thing here is that a leap year occurs:

```plain
on every year that is evenly divisible by 4
  except every year that is evenly divisible by 100
    except every year that is evenly divisible by 400.
```

For example, 1997 is not a leap year, but 1996 is.
1900 is not a leap year, but 2000 is.

Your program should be called as follows:

```ruby
Year.new(1996).leap?
```
## Extensions

### `.leap_year?`

Monkeypatch `Fixnum` to provide a `leap_year?` method:

```ruby
2000.leap_year?
```

### `.next_leap_year`

Add a `.next_leap_year` method to the `Date` class so you can say:

```ruby
Date.today.next_leap_year
```

## Notes

For a delightful, four minute explanation of the whole leap year phenomenon, go watch [this youtube video](http://www.youtube.com/watch?v=xX96xng7sAE).
