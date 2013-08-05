var Words = require('./words');

describe("Words", function() {

  it("counts one word", function() {
    var words = new Words("word");
    var expectedCounts = { "word" : 1 };
    expect(words.count).toEqual(expectedCounts);
  });

  xit("counts one of each", function() {
    var words = new Words("one of each");
    var expectedCounts = { "one": 1, "of": 1, "each": 1 };
    expect(words.count).toEqual(expectedCounts);
  });

  xit("counts multiple occurrences", function() {
    var words = new Words("one fish two fish red fish blue fish");
    var expectedCounts = { "one" : 1, "fish" : 4, "two" : 1, "red" : 1, "blue" : 1 };
    expect(words.count).toEqual(expectedCounts);
  });

  xit("ignores punctuation", function() {
    var words = new Words("car : carpet as java : javascript!!&@$%^&");
    var expectedCounts = { "car" : 1, "carpet" : 1, "as" : 1, "java" : 1, "javascript" : 1 };
    expect(words.count).toEqual(expectedCounts);
  });

  xit("includes numbers", function() {
    var words = new Words("testing, 1, 2 testing");
    var expectedCounts = { "testing" : 2, "1" : 1, "2" : 1 };
    expect(words.count).toEqual(expectedCounts);
  });

  xit("normalizes case", function() {
    var words = new Words("go Go GO");
    var expectedCounts = { "go" : 3 };
    expect(words.count).toEqual(expectedCounts);
  });

});

