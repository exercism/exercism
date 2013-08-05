'use strict';

module.exports = {
  strain: function(array, filter, keepMatches) {
    var results = [];
    for (var i=0; i < array.length; i++) {
      var item = array[i];
      if (filter(item) === keepMatches) {
        results.push(item);
      }
    }
    return results;
  },

  keep: function (array, filter) {
    return this.strain(array, filter, true);
  },

  discard: function (array, filter) {
    return this.strain(array, filter, false);
  }
};
