require('./hexadecimal');

describe("Hexadecimal", function() {

  it("hex 1 is decimal 1", function() {
    var hex = new Hexadecimal("1");
    expect(hex.toDecimal()).toEqual(1);
  });

  it("hex c is decimal 12", function() {
    var hex = new Hexadecimal("c");
    expect(hex.toDecimal()).toEqual(12);
  });

  it("hex 10 is decimal 16", function() {
    var hex = new Hexadecimal("10");
    expect(hex.toDecimal()).toEqual(16);
  });

  it("hex af is decimal 175", function() {
    var hex = new Hexadecimal("af");
    expect(hex.toDecimal()).toEqual(175);
  });

  it("hex 100 is decimal 256", function() {
    var hex = new Hexadecimal("100");
    expect(hex.toDecimal()).toEqual(256);
  });

  it("hex 19ace is decimal 105166", function() {
    var hex = new Hexadecimal("19ace");
    expect(hex.toDecimal()).toEqual(105166);
  });

  it("invalid hex is decimal 0", function() {
    var hex = new Hexadecimal("carrot");
    expect(hex.toDecimal()).toEqual(0);
  });

  it("black", function() {
    var hex = new Hexadecimal("000000");
    expect(hex.toDecimal()).toEqual(0);
  });

  it("white", function() {
    var hex = new Hexadecimal("ffffff");
    expect(hex.toDecimal()).toEqual(16777215);
  });

  it("yellow", function() {
    var hex = new Hexadecimal("ffff00");
    expect(hex.toDecimal()).toEqual(16776960);
  });

});