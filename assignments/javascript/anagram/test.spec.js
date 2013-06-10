require('./anagram');

describe('Anagram', function() {

  it("no matches",function() {
    var detector = new Anagram("diaper");
    var matches = detector.match([ "hello", "world", "zombies", "pants"]);
    expect(matches).toEqual([]);
  });

  it("detects simple anagram",function() {
    var detector = new Anagram("ba");
    var matches = detector.match(['ab', 'abc', 'bac']);
    expect(matches).toEqual(['ab']);
  });

  it("detects multiple anagrams",function() {
    var detector = new Anagram("abc");
    var matches = detector.match(['ab', 'abc', 'bac']);
    expect(matches).toEqual(['abc', 'bac']);
  });

  it("detects anagram",function() {
    var detector = new Anagram("listen");
    var matches = detector.match(['enlists', 'google', 'inlets', 'banana']);
    expect(matches).toEqual(['inlets']);
  });

  it("detects multiple anagrams",function() {
    var detector = new Anagram("allergy");
    var matches = detector.match(['gallery', 'ballerina', 'regally', 'clergy', 'largely', 'leading']);
    expect(matches).toEqual(['gallery', 'regally', 'largely']);
  });
});