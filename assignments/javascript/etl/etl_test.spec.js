var ETL = require('./transform');

describe("Transform", function() {

  it("transforms one value", function() {
    var old = { 'hello' : ['WORLD'] };
    var expected = { 'world' : 'hello' };
    expect(ETL.transform(old)).toEqual(expected);
  });

  xit("transforms more values", function() {
    var old = { 'hello' : ['WORLD', 'GSCHOOLERS'] };
    var expected = { 'world' : 'hello', 'gschoolers' : 'hello' };
    expect(ETL.transform(old)).toEqual(expected);
  });

  xit("transforms more keys", function() {
    var old = { 'a' : ['APPLE', 'ARTICHOKE'], 'b' : ['BOAT', 'BALLERINA'] };
    var expected = {
      'apple' : 'a',
      'artichoke' : 'a',
      'boat' : 'b',
      'ballerina' : 'b'
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
    }

    expect(ETL.transform(old)).toEqual(expected);
  });

});