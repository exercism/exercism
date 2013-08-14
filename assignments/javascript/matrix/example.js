'use strict';

function columnsFromRows(rows) {
  var columns = [];
  rows.forEach(function (row) {
    row.forEach(function (n, index) {
      columns[index] = columns[index] || [];
      columns[index].push(n);
    });
  });
  return columns;
}

function parseRows(description) {
  return description.split("\n").map(function (row) {
    return row.split(' ').map(function (char) {
      return parseInt(char, 10);
    });
  });
}

function Matrix(description) {
  this.rows = parseRows(description);
  this.columns = columnsFromRows(this.rows);
}

module.exports = Matrix;