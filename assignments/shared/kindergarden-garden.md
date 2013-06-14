The kindergarden class is learning about growing plants. The teachers thought it would be a good idea to give them actual seeds, plant them in actual dirt, and grow actual plants.

They've chosen to grow grass, clover, radishes, and violets.

To this end, they've put little styrofoam cups along the window sills, and
planted one type of plant in each cup, choosing randomly from the available
types of seeds.

```plain
[window][window][window]
........................ # each dot represents a styrofoam cup
........................
```

There are 12 children in the class:

Alice, Bob, Charlie, David, Eve, Fred, Ginny, Harriet, Ileana, Joseph,
Kincaid, and Larry.

Each child gets 4 cups, two on each row. The children are assigned to cups in alphabetical order.

The following diagram represents Alice's plants:

```plain
[window][window][window]
VR......................
RG......................
```

She has `[:violets, :radishes, :radishes, :grass]`.

```ruby
garden = Garden.new("VRCGVVRVCGGCCGVRGCVCGCGV\nVRCCCGCRRGVCGCRVVCVGCGCV")
garden.alice
# => [:violets, :radishes, :violets, :radishes]
garden.bob
# => [:clover, :grass, :clover, :clover]
```
