var converter = require('./roman');

describe("toRoman", function() {

  it("converts 1", function() {
    expect(converter.toRoman(1)).toEqual('I');
  });

  xit("converts 2", function() {
    expect(converter.toRoman(2)).toEqual('II');
  });

  xit("converts 3", function() {
    expect(converter.toRoman(3)).toEqual('III');
  });

  xit("converts 4", function() {
    expect(converter.toRoman(4)).toEqual('IV');
  });

  xit("converts 5", function() {
    expect(converter.toRoman(5)).toEqual('V');
  });

  xit("converts 6", function() {
    expect(converter.toRoman(6)).toEqual('VI');
  });

  xit("converts 9", function() {
    expect(converter.toRoman(9)).toEqual('IX');
  });

  xit("converts 27", function() {
    expect(converter.toRoman(27)).toEqual('XXVII');
  });

  xit("converts 48", function() {
    expect(converter.toRoman(48)).toEqual('XLVIII');
  });

  xit("converts 59", function() {
    expect(converter.toRoman(59)).toEqual('LIX');
  });

  xit("converts 93", function() {
    expect(converter.toRoman(93)).toEqual('XCIII');
  });

  xit("converts 141", function() {
    expect(converter.toRoman(141)).toEqual('CXLI');
  });

  xit("converts 163", function() {
    expect(converter.toRoman(163)).toEqual('CLXIII');
  });

  xit("converts 402", function() {
    expect(converter.toRoman(402)).toEqual('CDII');
  });

  xit("converts 575", function() {
    expect(converter.toRoman(575)).toEqual('DLXXV');
  });

  xit("converts 911", function() {
    expect(converter.toRoman(911)).toEqual('CMXI');
  });

  xit("converts 1024", function() {
    expect(converter.toRoman(1024)).toEqual('MXXIV');
  });

  xit("converts 3000", function() {
    expect(converter.toRoman(3000)).toEqual('MMM');
  });

});
