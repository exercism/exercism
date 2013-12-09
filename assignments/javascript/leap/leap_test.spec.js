var isLeapYear = require('./leap');

describe("Year", function() {
  it("a known leap year", function() {
    expect(isLeapYear(1996)).toBe(true);
  });

  xit("any old year", function() {
    expect(isLeapYear(1997)).not.toBe(true);
  });

  xit("turn of the 20th century", function() {
    expect(isLeapYear(1900)).not.toBe(true);
  });

  xit("turn of the 21st century", function() {
    expect(isLeapYear(2400)).toBe(true);
  });
});
