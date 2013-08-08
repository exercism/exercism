function Year(number) {
  'use strict';

  this.year = number;

  this.isLeapYear = function() {
    return this.yearDivisibleBy(4) &&
      ( ! this.yearDivisibleBy(100) || this.yearDivisibleBy(400) );
  };

  this.yearDivisibleBy = function(divisor) {
    return this.divisibleBy(this.year,divisor);
  };

  this.divisibleBy = function(number,divisor) {
    return number % divisor === 0;
  };
}

module.exports = Year;