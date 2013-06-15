Matrix = function Matrix(matrix) {
  this.rows = [];
  this.columns = [];

  var rows = matrix.split("\n");

  for (var i = 0; i < rows.length; i++) {
    var currentRow = rows[i].replace(/^\s+|\s+$/g,'').split(" ").map(function(x) { return parseInt(x); });
    this.rows.push(currentRow);
  };

  for (var i = 0; i < this.rows[0].length; i++) {
    this.columns.push([]);
  };

  for (var i = 0; i < this.rows.length; i++) {
    for (var j = 0; j < this.columns.length; j++) {
      this.columns[j].push(this.rows[i][j]);
    };
  };

  this.indexesOfMaxValues = function(array) {
    var maxValue, indexes = [];

    for (var i = 0; i < array.length; i++) {
      var currentElement = array[i];
      if (maxValue === undefined || currentElement > maxValue) {
        maxValue = currentElement;
        indexes = [i];
      } else if (currentElement == maxValue) {
        indexes.push(i);
      }
    };

    return indexes;
  };

  this.indexesOfMinValues = function(array) {
    var minValue, indexes = [];

    for (var i = 0; i < array.length; i++) {
      var currentElement = array[i];
      if (minValue === undefined || currentElement < minValue) {
        minValue = currentElement;
        indexes = [i];
      } else if (currentElement == minValue) {
        indexes.push(i);
      }
    };

    return indexes;
  }

  this.calculateSaddlePoints = function(rows,columns) {
    var saddlePoints = [];

    for (var i = 0; i < rows.length; i++) {

      var maxIndexes = this.indexesOfMaxValues(rows[i]);

      for (var j = 0; j < maxIndexes.length; j++) {

        var currentMaxIndex = maxIndexes[j];
        var minIndexes = this.indexesOfMinValues(columns[currentMaxIndex]);

        if (minIndexes.indexOf(i) >= 0) {
          saddlePoints.push([currentMaxIndex,i]);
        }
      };

    };
    return saddlePoints;
  }

  this.saddlePoints = this.calculateSaddlePoints(this.rows,this.columns);
}