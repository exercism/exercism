Anagram = require "./anagram" 
describe "Anagram", ->
  it "no matches", ->
    detector = new Anagram "diaper"
    matches = detector.match ["hello", "world", "zombies", "pants"]
    expect(matches).toEqual []

  xit "detects simple anagram", ->
    detector = new Anagram "ant"
    matches = detector.match ["tan", "stand", "at"]
    expect(matches).toEqual ["tan"]

  xit "does not detect false positives", ->
    detector = new Anagram "galea"
    matches = detector.match ["eagle"]
    expect(matches).toEqual []

  xit "detects multiple anagrams", ->
    detector = new Anagram "master"
    matches = detector.match ["stream", "pigeon", "maters"]
    expect(matches).toEqual ["stream", "maters"]

  xit "does not detect anagram subsets", ->
    detector = new Anagram "good"
    matches = detector.match ["dog", "goody"]
    expect(matches).toEqual []

  xit "detects anagram", ->
    detector = new Anagram "listen"
    matches = detector.match ["enlists", "google", "inlets", "banana"]
    expect(matches).toEqual ["inlets"]

  xit "detects multiple anagrams", ->
    detector = new Anagram "allergy"
    matches = detector.match ["gallery", "ballerina", "regally", "clergy", "largely", "leading"]
    expect(matches).toEqual ["gallery", "regally", "largely"]

  xit "does not detect identical words", ->
    detector = new Anagram "corn"
    matches = detector.match ["corn", "dark", "Corn", "rank", "CORN", "cron", "park"]
    expect(matches).toEqual ["cron"]

  xit "does not detect non-anagrams with identical checksum", ->
    detector = new Anagram "mass"
    matches = detector.match ["last"]
    expect(matches).toEqual []

  xit "detects anagrams using case-insensitive subject", ->
    detector = new Anagram "Orchestra"
    matches = detector.match ["cashregister", "carthorse", "radishes"]
    expect(matches).toEqual ["carthorse"]

  xit "detects anagrams using case-insensitive candidates", ->
    detector = new Anagram "orchestra"
    matches = detector.match ["cashregister", "Carthorse", "radishes"]
    expect(matches).toEqual ["carthorse"]
