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

module.exports = function (year) {
  var feb = 1;

  // if date is valid, `.getMonth` should return month (`feb`) given.
  return new Date(Number(year), feb, 29).getMonth() === feb;
};

