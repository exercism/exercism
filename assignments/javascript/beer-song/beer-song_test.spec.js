var Beer = require('./beer-song');

describe('Beer', function() {

  it('prints an arbitrary verse', function() {
    var expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n";
    expect(Beer.verse(8)).toEqual(expected);
  });

  xit('handles 1 bottle', function() {
    var expected = "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n";
    expect(Beer.verse(1)).toEqual(expected);
  });

  xit('handles 0 bottles', function() {
    var expected = "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n";
    expect(Beer.verse(0)).toEqual(expected);
  });

  xit('sings several verses', function() {
    var expected = "8 bottles of beer on the wall, 8 bottles of beer.\nTake one down and pass it around, 7 bottles of beer on the wall.\n\n7 bottles of beer on the wall, 7 bottles of beer.\nTake one down and pass it around, 6 bottles of beer on the wall.\n\n6 bottles of beer on the wall, 6 bottles of beer.\nTake one down and pass it around, 5 bottles of beer on the wall.\n";
    expect(Beer.sing(8, 6)).toEqual(expected);
  });

  xit('sings the rest of the verses', function() {
    var expected = "3 bottles of beer on the wall, 3 bottles of beer.\nTake one down and pass it around, 2 bottles of beer on the wall.\n\n2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n\n1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n\nNo more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n";
    expect(Beer.sing(3)).toEqual(expected);
  });
});
