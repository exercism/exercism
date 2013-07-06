var Binary = require('./example');

describe('binary', function() {

  it('1 is decimal 1', function() {
    expect(1).toEqual(new Binary('1').toDecimal());
  });

  it('10 is decimal 2', function() {
    expect(2).toEqual(new Binary('10').toDecimal());
  });

  it('11 is decimal 3', function() {
    expect(3).toEqual(new Binary('11').toDecimal());
  });

  it('100 is decimal 4', function() {
    expect(4).toEqual(new Binary('100').toDecimal());
  });

  it('1001 is decimal 9', function() {
    expect(9).toEqual(new Binary('1001').toDecimal());
  });

  it('11010 is decimal 26', function() {
    expect(26).toEqual(new Binary('11010').toDecimal());
  });

  it('10001101000 is decimal 1128', function() {
    expect(1128).toEqual(new Binary('10001101000').toDecimal());
  });

  it('carrot is decimal 0', function() {
    expect(0).toEqual(new Binary('carrot').toDecimal());
  });

});
