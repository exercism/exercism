'use strict';

module.exports = function(input) {
  var output = {};
  var object = Object.keys(input);

  function processKey(key) {
    var items = input[key] || [];

    items.forEach(function (item) {
      var value = item.toLowerCase();
      output[value] = Number(key);
    });
  }

  object.forEach(processKey);

  return output;
};
