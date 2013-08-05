var strain = require('./strain');

describe("strain", function() {

  it("keeps on empty array returns empty array", function() {
    expect(strain.keep([], function(e) { return e < 10 })).toEqual([]);
  });

  xit("keeps everything ", function() {
    expect(strain.keep([1, 2, 3], function(e) { return e < 10 })).toEqual([1, 2, 3]);
  });

  xit("keeps first and last", function() {
    expect(strain.keep([1, 2, 3], function(e) { return (e % 2) === 1 })).toEqual([1, 3]);
  });

  xit("keeps neither first nor last", function() {
    expect(strain.keep([1, 2, 3, 4, 5], function(e) { return (e % 2) === 0 })).toEqual([2, 4]);
  });

  xit("keeps strings", function() {
    var words = "apple zebra banana zombies cherimoya zelot".split(" ");
    var result = strain.keep(words, function(word) { return word.indexOf("z") === 0 });
    expect(result).toEqual("zebra zombies zelot".split(" "));
  });

  xit("keeps arrays", function() {
    var rows = [
      [1, 2, 3],
      [5, 5, 5],
      [5, 1, 2],
      [2, 1, 2],
      [1, 5, 2],
      [2, 2, 1],
      [1, 2, 5]
    ];
    var result = strain.keep(rows, function(row) { return row.indexOf(5) > -1 });
    expect(result).toEqual([[5, 5, 5], [5, 1, 2], [1, 5, 2], [1, 2, 5]]);
  });

  xit("empty discard", function() {
    expect(strain.discard([], function(e) { return e < 10})).toEqual([]);
  });

  xit("discards nothing", function() {
    expect(strain.discard([1, 2, 3], function(e) { return e > 10 })).toEqual([1, 2, 3]);
  });

  xit("discards first and last", function() {
    expect(strain.discard([1, 2, 3], function(e) { return e % 2 === 1 })).toEqual([2]);
  });

  xit("discards neither first nor last", function() {
    var result = strain.discard([1, 2, 3, 4, 5], function(e) { return e % 2 === 0 });
    expect(result).toEqual([1, 3, 5]);
  });

  xit("discards strings", function() {
    var words = "apple zebra banana zombies cherimoya zelot".split(" ");
    var result = strain.discard(words, function(word) { return word.indexOf("z") === 0 });
    expect(result).toEqual("apple banana cherimoya".split(" "));
  });

  xit("discards arrays", function() {
    var rows = [
      [1, 2, 3],
      [5, 5, 5],
      [5, 1, 2],
      [2, 1, 2],
      [1, 5, 2],
      [2, 2, 1],
      [1, 2, 5]
    ];
    var result = strain.discard(rows, function(row) { return row.indexOf(5) > -1 });
    expect(result).toEqual([[1, 2, 3], [2, 1, 2], [2, 2, 1]]);
  });

});

