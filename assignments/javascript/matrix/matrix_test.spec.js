var Matrix = require('./matrix');

describe('Matrix', function () {

  it('can extract a row', function () {
    expect(new Matrix("1 2\n10 20").rows[0]).toEqual([1, 2]);
  });

  xit('can extract the other row', function () {
    expect(new Matrix("9 8 7\n19 18 17").rows[1]).toEqual([19, 18, 17]);
  });

  xit('can extract a column', function () {
    expect(new Matrix("89 1903 3\n18 3 1\n9 4 800").columns[1])
      .toEqual([1903, 3, 4]);
  });

});