Array.prototype.accumulate = function(modify){
  var accumulator = [];

  this.forEach(function(element){
    accumulator.push(modify(element));
  });
  return accumulator;
};
