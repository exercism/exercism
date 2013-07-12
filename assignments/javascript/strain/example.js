Strain = {};

(function() {
  var strain = function(array, filter, keepMatches) {
    var results = [];
    for (var i=0; i < array.length; i++) {
      var item = array[i];
      if (filter(item) === keepMatches) {
        results.push(item);
      }
    }
    return results;
  };

  Strain.keep = function(array, filter) {
    return strain(array, filter, true);
  };

  Strain.discard = function(array, filter) {
    return strain(array, filter, false);
  };
})();
