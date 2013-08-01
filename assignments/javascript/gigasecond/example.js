function Gigasecond(dateOfBirth) {
  'use strict';

  this.dateOfBirth = dateOfBirth;

  this.date = function() {
    var gigasecondDate = new Date(this.dateOfBirth.getTime() + 1000000000000);
    return this.roundDownToDay(gigasecondDate);
  };

  this.roundDownToDay = function(date) {
    date.setHours(0);
    date.setMinutes(0);
    date.setSeconds(0);
    return date;
  };
}

module.exports = Gigasecond;