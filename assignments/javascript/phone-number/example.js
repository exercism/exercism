(function() {
  'use strict';

  function Phone(number) {
    this.rawNumber = number;
    this.cleanedNumber = this.cleanNumber(number);
  }

  Phone.prototype.cleanNumber = function(number) {
    var num = number.replace(/\D/g,'');

    if (num.length === 10) {
      return num;
    } else if (num.length === 11 && num[0] === "1") {
      return num.substr(1,num.length);
    } else {
      return "0000000000";
    }
  };

  Phone.prototype.number = function() {
    return this.cleanedNumber;
  };

  Phone.prototype.areaCode = function() {
    return this.number().substr(0,3);
  };

  Phone.prototype.exchangeCode = function() {
    return this.number().substr(3,3);
  };

  Phone.prototype.subscriberNumber = function() {
    return this.number().substr(6,4);
  };

  Phone.prototype.toString = function() {
    return "(" + this.areaCode() + ") " + this.exchangeCode() + "-" + this.subscriberNumber();
  };

  module.exports = Phone;
})();