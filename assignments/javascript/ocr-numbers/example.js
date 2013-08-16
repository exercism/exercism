'use strict';

var PATTERNS = {
  0: [" _ ",
      "| |",
      "|_|",
      "   "],
  1: ["   ",
      "  |",
      "  |",
      "   "],
  2: [" _ ",
      " _|",
      "|_ ",
      "   "],
  3: [" _ ",
      " _|",
      " _|",
      "   "],
  4: ["   ",
      "|_|",
      "  |",
      "   "],
  5: [" _ ",
      "|_ ",
      " _|",
      "   "],
  6: [" _ ",
      "|_ ",
      "|_|",
      "   "],
  7: [" _ ",
      "  |",
      "  |",
      "   "],
  8: [" _ ",
      "|_|",
      "|_|",
      "   "],
  9: [" _ ",
      "|_|",
      " _|",
      "   "]
};

function getDigit(text) {
  for (var digit in PATTERNS) {
    if (PATTERNS.hasOwnProperty(digit)) {
      if (PATTERNS[digit].join('') === text) {
        return digit;
      }
    }
  }
  return '?';
}

function splitIntoDigits(row) {
  var digits = [];
  var rows = row.split("\n");
  for (var digitNumber = 0; digitNumber < rows[0].length; digitNumber += 3) {
    var digit = '';
    for (var rowNumber = 0; rowNumber < rows.length; rowNumber++) {
      digit += rows[rowNumber].substr(digitNumber, 3);
    }
    digits.push(digit);
  }
  return digits;
}

function splitIntoRows(text) {
  var rows = [];
  var lines = text.split("\n");
  for (var rowNumber = 0; rowNumber < lines.length; rowNumber += 4) {
    var row = '';
    for (var rowLine = 0; rowLine < 4; rowLine++) {
      row += lines[rowNumber + rowLine] + "\n";
    }
    rows.push(row.slice(0, -1));
  }
  return rows;
}

function valuesInRow(row) {
  var digits = splitIntoDigits(row);
  return digits.map(getDigit).join('');
}

exports.convert = function (text) {
  var rows = splitIntoRows(text);
  return rows.map(valuesInRow).join(',');
};