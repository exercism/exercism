var Raindrops = require('./raindrops');

describe("Raindrops", function() {
  var drops = new Raindrops();

  it("converts 1", function() {
    expect(drops.convert(1)).toEqual("1");
  });

  xit("converts 3", function() {
    expect(drops.convert(3)).toEqual("Pling");
  });

  xit("converts 5", function() {
    expect(drops.convert(5)).toEqual("Plang");
  });

  xit("converts 7", function() {
    expect(drops.convert(7)).toEqual("Plong");
  });

  xit("converts 6", function() {
    expect(drops.convert(6)).toEqual("Pling");
  });

  xit("converts 9", function() {
    expect(drops.convert(9)).toEqual("Pling");
  });

  xit("converts 10", function() {
    expect(drops.convert(10)).toEqual("Plang");
  });

  xit("converts 14", function() {
    expect(drops.convert(14)).toEqual("Plong");
  });

  xit("converts 15", function() {
    expect(drops.convert(15)).toEqual("PlingPlang");
  });

  xit("converts 21", function() {
    expect(drops.convert(21)).toEqual("PlingPlong");
  });

  xit("converts 25", function() {
    expect(drops.convert(25)).toEqual("Plang");
  });

  xit("converts 35", function() {
    expect(drops.convert(35)).toEqual("PlangPlong");
  });

  xit("converts 49", function() {
    expect(drops.convert(49)).toEqual("Plong");
  });

  xit("converts 52", function() {
    expect(drops.convert(52)).toEqual("52");
  });

  xit("converts 105", function() {
    expect(drops.convert(105)).toEqual("PlingPlangPlong");
  });

  xit("converts 12121", function() {
    expect(drops.convert(12121)).toEqual("12121");
  });

});