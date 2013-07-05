Array.prototype.accumulate = function(accumulator) {
  if (typeof Array.prototype.map == 'function') {
    return this.map(accumulator);
  }

  var idx = 0;
  var out = [];
  var end = this.length;

  for (; idx < end; ++idx) {
    out.push(accumulator(this[idx]));
  }

  return out;
};
