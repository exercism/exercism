var Binary = require('./binary');

describe('binary', function() {

  it('1 is decimal 1', function() {
    expect(new Binary('1').toDecimal()).toEqual(1);
  });

  xit('10 is decimal 2', function() {
    expect(new Binary('10').toDecimal()).toEqual(2);
  });

  xit('11 is decimal 3', function() {
    expect(new Binary('11').toDecimal()).toEqual(3);
  });

  xit('100 is decimal 4', function() {
    expect(new Binary('100').toDecimal()).toEqual(4);
  });

  xit('1001 is decimal 9', function() {
    expect(new Binary('1001').toDecimal()).toEqual(9);
  });

  xit('11010 is decimal 26', function() {
    expect(new Binary('11010').toDecimal()).toEqual(26);
  });

  xit('10001101000 is decimal 1128', function() {
    expect(new Binary('10001101000').toDecimal()).toEqual(1128);
  });

  xit('carrot is decimal 0', function() {
    expect(new Binary('carrot').toDecimal()).toEqual(0);
  });

});