Given an age in seconds, calculate how old someone would be on:
   - Earth (orbital period 365.25 Earth days, or 31557600 seconds)
   - Mercury (orbital period 0.2408467 Earth years)
   - Venus (orbital period 0.61519726 Earth years)
   - Mars (orbital period 1.8808158 Earth years)
   - Jupiter (orbital period 11.862615 Earth years)
   - Saturn (orbital period 29.447498 Earth years)
   - Uranus (orbital period 84.016846 Earth years)
   - Neptune (orbital period 164.79132 Earth years)

```ruby
age = SpaceAge.new(1_000_000_000)
assert_equal 31, age.on_earth
```

If you're wondering why Pluto didn't make the cut, go watch [this youtube video](http://www.youtube.com/watch?v=Z_2gbGXzFbs).
