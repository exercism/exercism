var Anagram = require('./anagram');

describe('Anagram', function() {

  it("no matches",function() {
    var detector = new Anagram("diaper");
    var matches = detector.match([ "hello", "world", "zombies", "pants"]);
    expect(matches).toEqual([]);
  });

  xit("detects simple anagram",function() {
    var detector = new Anagram("ant");
    var matches = detector.match(['tan', 'stand', 'at']);
    expect(matches).toEqual(['tan']);
  });

  xit("does not detect false positives",function() {
    var detector = new Anagram("galea");
    var matches = detector.match(["eagle"]);
    expect(matches).toEqual([]);
  });

  xit("detects multiple anagrams",function() {
    var detector = new Anagram("master");
    var matches = detector.match(['stream', 'pigeon', 'maters']);
    expect(matches).toEqual(['stream', 'maters']);
  });

  xit("does not detect anagram subsets",function() {
    var detector = new Anagram("good");
    var matches = detector.match(['dog', 'goody']);
    expect(matches).toEqual([]);
  });

  xit("detects anagram",function() {
    var detector = new Anagram("listen");
    var matches = detector.match(['enlists', 'google', 'inlets', 'banana']);
    expect(matches).toEqual(['inlets']);
  });

  xit("detects multiple anagrams",function() {
    var detector = new Anagram("allergy");
    var matches = detector.match(['gallery', 'ballerina', 'regally', 'clergy', 'largely', 'leading']);
    expect(matches).toEqual(['gallery', 'regally', 'largely']);
  });

  xit("detects anagrams case-insensitively",function() {
    var detector = new Anagram("Orchestra");
    var matches = detector.match(['cashregister', 'Carthorse', 'radishes']);
    expect(matches).toEqual(['Carthorse']);
  });

  xit("does not detect a word as its own anagram",function() {
    var detector = new Anagram("banana");
    var matches = detector.match(['banana']);
    expect(matches).toEqual([]);
  });
});
