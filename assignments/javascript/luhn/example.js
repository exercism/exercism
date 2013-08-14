'use strict';

function Luhn(number) {
  this.checkDigit = number % 10;
  this.addends = this.calculateAddends(number);
  this.checksum = this.calculateChecksum(this.addends);
  this.valid = this.determineIfValid(this.checksum);
}

Luhn.prototype = {
  calculateAddends: function(number) {

    var numberAsString = "" + number + "";
    var numbers = numberAsString.split('');
    var addends = [];

    for (var i = 0; i < numbers.length; i++) {
      var index = numbers.length - 1 - i;

      var currentAddend = parseInt(numbers[index], 10);

      if ((i + 1) % 2 === 0) {
        currentAddend = currentAddend * 2;
        if (currentAddend > 10) {
          currentAddend = currentAddend - 9;
        }
      }

      addends.push(currentAddend);
    }

    return addends.reverse();

  },
  calculateChecksum: function(numbers) {
    var sum = 0;
    for (var i = 0; i < numbers.length; i++) {
      sum += numbers[i];
    }

    return sum;
  },
  determineIfValid: function(sum) {
    return (sum % 10 === 0);
  }
};

Luhn.create = function(number) {
  var finalNumber = number * 10;
  var luhnNumber = new Luhn(finalNumber);
  var index = 0;

  while(!luhnNumber.valid) {
    finalNumber = number * 10 + index;
    luhnNumber = new Luhn(finalNumber);
    if (luhnNumber.valid) { break; }
    index += 1;
  }

  return finalNumber;
};

module.exports = Luhn;