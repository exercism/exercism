var Year = require('./year');

describe("Year", function() {

  it("a known leap year", function() {
    var year = new Year(1996);
    expect(year.isLeapYear()).toBeTruthy();
  });

  xit("any old year", function() {
    var year = new Year(1997);
    expect(year.isLeapYear()).not.toBeTruthy();
  });

  xit("turn of the 20th century", function() {
    var year = new Year(1900);
    expect(year.isLeapYear()).not.toBeTruthy();
  });

  xit("turn of the 21st century", function() {
    var year = new Year(2000);
    expect(year.isLeapYear()).toBeTruthy();
  });

});
