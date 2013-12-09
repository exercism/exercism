var toRoman = require('./roman-numerals');

describe("toRoman()", function() {
  it("converts 1", function() {
    expect(toRoman(1)).toEqual('I');
  });

  xit("converts 2", function() {
    expect(toRoman(2)).toEqual('II');
  });

  xit("converts 3", function() {
    expect(toRoman(3)).toEqual('III');
  });

  xit("converts 4", function() {
    expect(toRoman(4)).toEqual('IV');
  });

  xit("converts 5", function() {
    expect(toRoman(5)).toEqual('V');
  });

  xit("converts 6", function() {
    expect(toRoman(6)).toEqual('VI');
  });

  xit("converts 9", function() {
    expect(toRoman(9)).toEqual('IX');
  });

  xit("converts 27", function() {
    expect(toRoman(27)).toEqual('XXVII');
  });

  xit("converts 48", function() {
    expect(toRoman(48)).toEqual('XLVIII');
  });

  xit("converts 59", function() {
    expect(toRoman(59)).toEqual('LIX');
  });

  xit("converts 93", function() {
    expect(toRoman(93)).toEqual('XCIII');
  });

  xit("converts 141", function() {
    expect(toRoman(141)).toEqual('CXLI');
  });

  xit("converts 163", function() {
    expect(toRoman(163)).toEqual('CLXIII');
  });

  xit("converts 402", function() {
    expect(toRoman(402)).toEqual('CDII');
  });

  xit("converts 575", function() {
    expect(toRoman(575)).toEqual('DLXXV');
  });

  xit("converts 911", function() {
    expect(toRoman(911)).toEqual('CMXI');
  });

  xit("converts 1024", function() {
    expect(toRoman(1024)).toEqual('MXXIV');
  });

  xit("converts 3000", function() {
    expect(toRoman(3000)).toEqual('MMM');
  });
});
