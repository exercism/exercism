Phone = function Phone(number) {
  this.rawNumber = number
  this.cleanedNumber = this.cleanNumber(number);
};

Phone.prototype = {
  cleanNumber: function(number) {
    var num = number.replace(/\D/g,'');

    if (num.length === 10) {
      return num;
    } else if (num.length === 11 && num[0] === "1") {
      return num.substr(1,num.length);
    } else {
      return "0000000000";
    }
  },
  number: function() {
    return this.cleanedNumber;
  },
  areaCode: function() {
    return this.number().substr(0,3);
  },
  numberPrefix: function() {
    return this.number().substr(3,3);
  },
  numberSuffix: function() {
    return this.number().substr(6,4);
  },
  toString: function() {
    return "(" + this.areaCode() + ") " + this.numberPrefix() + "-" + this.numberSuffix();
  }

};
