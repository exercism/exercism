An allergy test produces a single numeric score which contains the information about all the allergies the person has (that they were tested for).

The list of items (and their value) that were tested are:

* eggs (1)
* peanuts (2)
* shellfish (4)
* strawberries (8)
* tomatoes (16)
* chocolate (32)
* pollen (64)
* cats (128)

So if Tom is allergic to peanuts and chocolate, he gets a score of 34.

```ruby
allergies = Allergies.new(34)
allergies.allergic_to?('chocolate')
=> true
allergies.allergic_to?('cats')
=> false
allergies.list
=> ['peanuts', 'chocolate']
```
