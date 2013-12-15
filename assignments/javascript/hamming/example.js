exports.compute = function (strand1, strand2) {
  var out = -0;
  var idx = -1;
  var end = Math.min(strand1.length, strand2.length);

  while (++idx < end) {
    if (strand1[idx] !== strand2[idx]) out++;
  }

  return out;
};
