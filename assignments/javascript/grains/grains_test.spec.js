var Grains = require('./grains');

describe("Grains", function () {
  var grains = new Grains();

  it("square 1", function () {
    expect(grains.square(1)).toEqual(1);
  });

  xit("square 2", function () {
    expect(grains.square(2)).toEqual(2);
  });

  xit("square 3", function () {
    expect(grains.square(3)).toEqual(4);
  });

  xit("square 4", function () {
    expect(grains.square(4)).toEqual(8);
  });

  xit("square 16", function () {
    expect(grains.square(16)).toEqual(32768);
  });

  xit("square 32", function () {
    expect(grains.square(32)).toEqual(2147483648);
  });

  xit("square 64", function () {
    expect(grains.square(64)).toEqual(9223372036854775808);
  });

  xit("total", function () {
    expect(grains.total()).toEqual(18446744073709551615);
  });
});