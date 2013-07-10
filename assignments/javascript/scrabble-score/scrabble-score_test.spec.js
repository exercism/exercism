require('./scrabble');

describe('Scrabble', function() {
  it("scores an empty word as zero",function() {
    var score = Scrabble.score("");
    expect(score).toEqual(0);
  });

  xit("scores a null as zero",function() {
    var score = Scrabble.score(null);
    expect(score).toEqual(0);
  });

  xit("scores a very short word",function() {
    var score = Scrabble.score("a");
    expect(score).toEqual(1);
  });

  xit("scores the word by the number of letters",function() {
    var score = Scrabble.score("street");
    expect(score).toEqual(6);
  });

  xit("scores more complicated words with more",function() {
    var score = Scrabble.score("quirky");
    expect(score).toEqual(22);
  });

  xit("scores case insensitive words",function() {
    var score = Scrabble.score("MULTIBILLIONAIRE");
    expect(score).toEqual(20);
  });
});