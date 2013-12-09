'use strict';

/**
 * Whether given year is a leap year.
 *
 * @param  {number} year
 * Numeric year.
 *
 * @return {boolean}
 * Whether given year is a leap year.
 */

module.exports = function (year) {
  return (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0));
};

