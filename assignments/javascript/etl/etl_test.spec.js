var ETL = require('./transform');

describe("Transform", function() {

  it("transforms one value", function() {
    var old = { 1 : ['WORLD'] };
    var expected = { 'world' : 1 };
    expect(ETL.transform(old)).toEqual(expected);
  });

  xit("transforms more values", function() {
    var old = { 1 : ['WORLD', 'GSCHOOLERS'] };
    var expected = { 'world' : 1, 'gschoolers' : 1 };
    expect(ETL.transform(old)).toEqual(expected);
  });

  xit("transforms more keys", function() {
    var old = { 1 : ['APPLE', 'ARTICHOKE'], 2 : ['BOAT', 'BALLERINA'] };
    var expected = {
      'apple' : 1,
      'artichoke' : 1,
      'boat' : 2,
      'ballerina' : 2
    };

    expect(ETL.transform(old)).toEqual(expected);
  });

  xit("transforms a full dataset", function() {

    var old = {
      "1" : [ "A", "E", "I", "O", "U", "L", "N", "R", "S", "T" ],
      "2" : [ "D", "G" ],
      "3" : [ "B", "C", "M", "P" ],
      "4" : [ "F", "H", "V", "W", "Y" ],
      "5" : [ "K" ],
      "8" : [ "J", "X" ],
      "10" : [ "Q", "Z" ]
    };

    var expected = {
      "a" : "1", "b" : "3", "c" : "3", "d" : "2", "e" : "1",
      "f" : "4", "g" : "2", "h" : "4", "i" : "1", "j" : "8",
      "k" : "5", "l" : "1", "m" : "3", "n" : "1", "o" : "1",
      "p" : "3", "q" : "10", "r" : "1", "s" : "1", "t" : "1",
      "u" : "1", "v" : "4", "w" : "4", "x" : "8", "y" : "4",
      "z" : "10"
    };

    expect(ETL.transform(old)).toEqual(expected);
  });

});
