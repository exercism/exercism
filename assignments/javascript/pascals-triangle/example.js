'use strict';

function sumElements(element, index, array) {
  /*jshint validthis:true */
  this.push(element + (array[index+1] || 0));
}

function fillRows(rows) {
  var result = [[1]];
  for (var x = 1; x < rows; x++) {
    var newRow = [1];
    result[x-1].forEach(sumElements, newRow);
    result.push(newRow);
  }
  return result;
}

function Triangle(rows) {
  this.rows = fillRows(rows);
  this.lastRow = this.rows[this.rows.length - 1];
}

module.exports = Triangle;