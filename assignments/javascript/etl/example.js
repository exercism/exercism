(function () {
  'use strict';

  var ETL = {
    transform : function(input) {
      var transformedObject = {};

      for (var key in input) {
        var currentValues = input[key];

        for (var i = 0; i < currentValues.length; i++) {
          var currentValue = currentValues[i].toLowerCase();
          transformedObject[currentValue] = key;
        }
      }
      return transformedObject;
    }
  };

  module.exports = ETL;
})();