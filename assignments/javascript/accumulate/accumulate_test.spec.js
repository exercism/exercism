var accumulate = require('./accumulate');

describe('accumulate()', function() {

  it('accumulation empty', function() {
    var accumulator = function(e) { return e * e; };
    expect([]).toEqual(accumulate([], accumulator));
  });

  xit('accumulate squares', function() {
    var accumulator = function(number) {
      return number * number;
    };

    var result = accumulate([1, 2, 3], accumulator);

    expect([1, 4, 9]).toEqual(result);
  });

  xit('accumulate upcases', function() {
    var accumulator = function(word) {
      return word.toUpperCase();
    };

    var result = accumulate('hello world'.split(/\s/), accumulator);

    expect(['HELLO', 'WORLD']).toEqual(result);
  });

  xit('accumulate reversed strings', function() {
    var accumulator = function(word) {
      return word.split('').reverse().join('');
    };

    var result = accumulate('the quick brown fox etc'.split(/\s/), accumulator);

    expect(["eht", "kciuq", "nworb", "xof", "cte"]).toEqual(result);
  });

  xit('accumulate recursively', function() {
    var result = accumulate('a b c'.split(/\s/), function(char) {
      return accumulate('1 2 3'.split(/\s/), function(digit) {
        return char + digit;
      });
    });

    expect([["a1", "a2", "a3"], ["b1", "b2", "b3"], ["c1", "c2", "c3"]]).toEqual(result);
  });

});
