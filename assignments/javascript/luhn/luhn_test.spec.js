require('./luhn');

describe('Luhn',function() {

  it("check digit",function() {
    var luhn = new Luhn(34567);
    expect(luhn.checkDigit).toEqual(7);
  });

  xit("check digit again",function() {
    var luhn = new Luhn(91370);
    expect(luhn.checkDigit).toEqual(0);
  });

  xit("addends",function() {
    var luhn = new Luhn(12121);
    expect(luhn.addends).toEqual([1, 4, 1, 4, 1]);
  });

  xit("too large added",function() {
    var luhn = new Luhn(8631);
    expect(luhn.addends).toEqual([7, 6, 6, 1]);
  });

  xit("checksum",function() {
    var luhn = new Luhn(4913);
    expect(luhn.checksum).toEqual(22);
  });

  xit("checksum again",function() {
    var luhn = new Luhn(201773);
    expect(luhn.checksum).toEqual(21);
  });

  xit("invalid number",function() {
    var luhn = new Luhn(738);
    expect(luhn.valid).toEqual(false);
  });

  xit("invalid number",function() {
    var luhn = new Luhn(8739567);
    expect(luhn.valid).toEqual(true);
  });

  xit("create valid number",function() {
    var number = Luhn.create(123);
    expect(number).toEqual(1230);
  });

  xit("create other valid number",function() {
    var number = Luhn.create(873956);
    expect(number).toEqual(8739567);
  });

  xit("create yet another valid number",function() {
    var number = Luhn.create(837263756);
    expect(number).toEqual(8372637564);
  });

});