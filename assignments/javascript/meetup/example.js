function Meetup(month,year) {
  'use strict';

  var meetup = {};

  meetup.startingDate = new Date(year,month,1);

  var daysOfTheWeek = [ "Sunday", "Monday", "Tuesday", "Wednesday",
    "Thursday", "Friday", "Saturday" ];


  for (var weekDayIndex = 0; weekDayIndex < daysOfTheWeek.length; weekDayIndex++) {
    var currentDay = daysOfTheWeek[weekDayIndex];

    var prefix = currentDay.replace(/day$/,'').toLowerCase();

    meetup[prefix + "teenth"] = generateWeekdayFunctionStartingAt(weekDayIndex,12);

    meetup["first" + currentDay] = generateWeekdayFunctionStartingAt(weekDayIndex,0);
    meetup["second" + currentDay] = generateWeekdayFunctionStartingAt(weekDayIndex,7);

    meetup["third" + currentDay] = generateWeekdayFunctionStartingAt(weekDayIndex,14);
    meetup["fourth" + currentDay] = generateWeekdayFunctionStartingAt(weekDayIndex,21);

    var lastDayOfMonth = new Date(year,month + 1,0).getDate() - 1;
    meetup["last" + currentDay] = generateWeekdayFunctionEndingAt(weekDayIndex,lastDayOfMonth);

  }

  function generateWeekdayFunctionStartingAt(weekDayIndex,offset) {
    return function() {
      this.startingDate.setDate(this.startingDate.getDate() + offset);
      var dayDifference = weekDayIndex - this.startingDate.getDay();
      dayDifference = (7 + dayDifference) % 7;
      this.startingDate.setDate(this.startingDate.getDate() + dayDifference);

      return this.startingDate;
    };
  }

  function generateWeekdayFunctionEndingAt(weekDayIndex,offset) {
    return function() {
      this.startingDate.setDate(this.startingDate.getDate() + offset);
      var dayDifference = this.startingDate.getDay() - weekDayIndex;
      dayDifference = (7 + dayDifference) % 7;
      this.startingDate.setDate(this.startingDate.getDate() - dayDifference);

      return this.startingDate;
    };
  }

  return meetup;
  
}

module.exports = Meetup;