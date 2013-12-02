Beer = require("./beer")
describe "Beer", ->
  it "prints an arbitrary verse", ->
    expect(Beer.verse 8).toEqual """
    8 bottles of beer on the wall, 8 bottles of beer.
    Take one down and pass it around, 7 bottles of beer on the wall.
    """

  xit "handles 1 bottle", ->
    expect(Beer.verse 1).toEqual """
    1 bottle of beer on the wall, 1 bottle of beer.
    Take it down and pass it around, no more bottles of beer on the wall.
    """

  xit "handles 0 bottles", ->
    expect(Beer.verse 0).toEqual """
    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.
    """

  xit "sings several verses", ->
    expect(Beer.sing 8, 6).toEqual """
    8 bottles of beer on the wall, 8 bottles of beer.
    Take one down and pass it around, 7 bottles of beer on the wall.

    7 bottles of beer on the wall, 7 bottles of beer.
    Take one down and pass it around, 6 bottles of beer on the wall.

    6 bottles of beer on the wall, 6 bottles of beer.
    Take one down and pass it around, 5 bottles of beer on the wall.

    """

  xit "sings the rest of the verses", ->
    expect(Beer.sing 3).toEqual """
    3 bottles of beer on the wall, 3 bottles of beer.
    Take one down and pass it around, 2 bottles of beer on the wall.

    2 bottles of beer on the wall, 2 bottles of beer.
    Take one down and pass it around, 1 bottle of beer on the wall.

    1 bottle of beer on the wall, 1 bottle of beer.
    Take it down and pass it around, no more bottles of beer on the wall.

    No more bottles of beer on the wall, no more bottles of beer.
    Go to the store and buy some more, 99 bottles of beer on the wall.

    """


