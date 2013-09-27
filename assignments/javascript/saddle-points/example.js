'use strict';

function toInt(s) {
  return parseInt(s, 10);
}

module.exports = function Matrix(matrix) {
  this.rows = [];
  this.columns = [];

  var rows = matrix.split("\n");
  var i, j, currentRow;

  for (i = 0; i < rows.length; i++) {
    currentRow = rows[i].replace(/^\s+|\s+$/g,'').split(" ").map( toInt );
    this.rows.push(currentRow);
  }

  for (i = 0; i < this.rows[0].length; i++) {
    this.columns.push([]);
  }

  for (i = 0; i < this.rows.length; i++) {
    for (j = 0; j < this.columns.length; j++) {
      this.columns[j].push(this.rows[i][j]);
    }
  }

  this.indexesOfMaxValues = function(array) {
    var i, currentElement, maxValue, indexes = [];

    for (i = 0; i < array.length; i++) {
      currentElement = array[i];
      if (maxValue === undefined || currentElement > maxValue) {
        maxValue = currentElement;
        indexes = [i];
      } else if (currentElement === maxValue) {
        indexes.push(i);
      }
    }

    return indexes;
  };

  this.indexesOfMinValues = function(array) {
    var i, currentElement, minValue, indexes = [];

    for (i = 0; i < array.length; i++) {
      currentElement = array[i];
      if (minValue === undefined || currentElement < minValue) {
        minValue = currentElement;
        indexes = [i];
      } else if (currentElement === minValue) {
        indexes.push(i);
      }
    }

    return indexes;
  };

  this.calculateSaddlePoints = function(rows,columns) {
    var i, j, maxIndexes, minIndexes, currentMaxIndex, saddlePoints = [];

    for (i = 0; i < rows.length; i++) {

      maxIndexes = this.indexesOfMaxValues(rows[i]);

      for (j = 0; j < maxIndexes.length; j++) {

        currentMaxIndex = maxIndexes[j];
        minIndexes = this.indexesOfMinValues(columns[currentMaxIndex]);

        if (minIndexes.indexOf(i) >= 0) {
          saddlePoints.push([i, currentMaxIndex]);
        }
      }

    }
    return saddlePoints;
  };

  this.saddlePoints = this.calculateSaddlePoints(this.rows,this.columns);
};