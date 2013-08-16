'use strict';

var smallNumbers = {
  0 : 'zero',
  1 : 'one',
  2 : 'two',
  3 : 'three',
  4 : 'four',
  5 : 'five',
  6 : 'six',
  7 : 'seven',
  8 : 'eight',
  9 : 'nine',
  10: 'ten',
  11: 'eleven',
  12: 'twelve',
  13: 'thirteen',
  14: 'fourteen',
  15: 'fifteen',
  16: 'sixteen',
  17: 'seventeen',
  18: 'eighteen',
  19: 'nineteen'
};

var decades = {
  20: 'twenty',
  30: 'thirty',
  40: 'forty',
  50: 'fifty',
  60: 'sixty',
  70: 'seventy',
  80: 'eighty',
  90: 'ninety'
};

var bigNumbers = {
        1000: 'thousand',
     1000000: 'million',
  1000000000: 'billion'
};

function bigPart(number) {
  var factor, result = '';
  for (var bigNumber = 1000000000; bigNumber >= 1000; bigNumber /= 1000) {
    if (number.current >= bigNumber) {
      factor = Math.floor(number.current/bigNumber);
      result += threeDigit(factor) + ' ' + bigNumbers[bigNumber] + ' ';
      number.current = number.current-(factor*bigNumber);
    }
  }
  return result;
}

function sayDecade(n) {
  for (var decade = 90; decade >= 20; decade -= 10) {
    if (n >= decade) {
      return decades[decade] + '-' + smallNumbers[n-decade];
    }
  }
}

function twoDigit(n) {
  var result;
  if (n < 20) {
    result = smallNumbers[n];
  } else {
    result = sayDecade(n);
  }
  return result;
}

function threeDigit(n) {
  if (n < 100) {
    return twoDigit(n);
  } else {
    return smallNumbers[Math.floor(n/100)] + ' hundred ' + twoDigit(n%100);
  }
}

exports.inEnglish = function (n) {
  var result, number = {current: n};
  if (0 <= n && n < 1000000000000) {
    result = bigPart(number);
    result += threeDigit(number.current);
    return result.replace(/.zero/, '');
  } else {
    throw new Error('Number must be between 0 and 999,999,999,999.');
  }
};