var accumulate = module.exports = function (list, accumulator) {
  var out = [];
  var idx = -1;
  var end = Array.isArray(list) ? list.length : 0;

  while (++idx < end) {
    out.push(accumulator(list[idx]));
  }

  return out;
};

