'use strict';

/**
 * Whether given year is a leap year.
 *
 * @param  {number|string} year
 * Year as a number or string.
 *
 * @return {boolean}
 * Whether given year is a leap year.
 */

var isLeapYear = module.exports = function (year) {
  var date;

  year = Number(year);
  date = new Date(year, 1, 29); // feb 29 valid only in leap year

  return !(date.getMonth() - 1);
};

