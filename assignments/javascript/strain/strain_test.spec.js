require('./strain');

describe("strain", function() {

  it("keeps on empty array returns empty array", function() {
    expect(Strain.keep([], function(e) { return e < 10 })).toEqual([]);
  });

  xit("keeps everything ", function() {
    expect(Strain.keep([1, 2, 3], function(e) { return e < 10 })).toEqual([1, 2, 3]);
  });

  xit("keeps first and last", function() {
    expect(Strain.keep([1, 2, 3], function(e) { return (e % 2) === 1 })).toEqual([1, 3]);
  });

  xit("keeps neither first nor last", function() {
    expect(Strain.keep([1, 2, 3, 4, 5], function(e) { return (e % 2) === 0 })).toEqual([2, 4]);
  });

  xit("keeps strings", function() {
    var words = "apple zebra banana zombies cherimoya zelot".split(" ");
    var result = Strain.keep(words, function(word) { return word.indexOf("z") === 0 });
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
    var result = Strain.keep(rows, function(row) { return row.indexOf(5) > -1 });
    expect(result).toEqual([[5, 5, 5], [5, 1, 2], [1, 5, 2], [1, 2, 5]]);
  });

  xit("empty discard", function() {
    expect(Strain.discard([], function(e) { return e < 10})).toEqual([]);
  });

  xit("discards nothing", function() {
    expect(Strain.discard([1, 2, 3], function(e) { return e > 10 })).toEqual([1, 2, 3]);
  });

  xit("discards first and last", function() {
    expect(Strain.discard([1, 2, 3], function(e) { return e % 2 === 1 })).toEqual([2]);
  });

  xit("discards neither first nor last", function() {
    var result = Strain.discard([1, 2, 3, 4, 5], function(e) { return e % 2 === 0 });
    expect(result).toEqual([1, 3, 5]);
  });

  xit("discards strings", function() {
    var words = "apple zebra banana zombies cherimoya zelot".split(" ");
    var result = Strain.discard(words, function(word) { return word.indexOf("z") === 0 });
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
    var result = Strain.discard(rows, function(row) { return row.indexOf(5) > -1 });
    expect(result).toEqual([[1, 2, 3], [2, 1, 2], [2, 2, 1]]);
  });

});

