var score = require('./scrabble-score');

describe('Scrabble', function() {
  it("scores an empty word as zero",function() {
    expect(score("")).toEqual(0);
  });

  xit("scores a null as zero",function() {
    expect(score(null)).toEqual(0);
  });

  xit("scores a very short word",function() {
    expect(score("a")).toEqual(1);
  });

  xit("scores the word by the number of letters",function() {
    expect(score("street")).toEqual(6);
  });

  xit("scores more complicated words with more",function() {
    expect(score("quirky")).toEqual(22);
  });

  xit("scores case insensitive words",function() {
    expect(score("MULTIBILLIONAIRE")).toEqual(20);
  });
});
