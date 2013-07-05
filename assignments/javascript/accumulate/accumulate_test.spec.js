require('./example');

describe('[].accumulate()',function() {

  it('empty accumulation', function () {
    var accumulator = function (e) { return e * e; };
    expect([]).toEqual([].accumulate(accumulator));
  });

  it('accumulate squares', function () {
    var accumulator = function (number) {
      return number * number;
    };

    var result = [1, 2, 3].accumulate(accumulator);

    expect([1, 4, 9]).toEqual(result);
  });

  it('accumulate upcases', function () {
    var accumulator = function (word) {
      return word.toUpperCase();
    };

    var result = 'hello world'.split(/\s/).accumulate(accumulator);

    expect(['HELLO', 'WORLD']).toEqual(result);
  });

  it('accumulate reversed strings', function () {
    var accumulator = function (word) {
      return word.split('').reverse().join('');
    };

    var result = 'the quick brown fox etc'.split(/\s/).accumulate(accumulator);

    expect(["eht", "kciuq", "nworb", "xof", "cte"]).toEqual(result);
  });

  it('accumulate recursively', function () {
    var result = 'a b c'.split(/\s/).accumulate(function (char) {
      return '1 2 3'.split(/\s/).accumulate(function (digit) {
        return char + digit;
      });
    });

    expect([["a1", "a2", "a3"], ["b1", "b2", "b3"], ["c1", "c2", "c3"]]).toEqual(result);
  });

});
