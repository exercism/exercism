Array.prototype.accumulate = function(accumulator) {
  if (typeof Array.prototype.map == 'function') {
    return this.map(accumulator);
  }

  var out = [];
  var end = this.length;

  for (var i = 0; i < end; i++) {
    out.push(accumulator(this[i]));
  }

  return out;
};
