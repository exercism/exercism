'use strict';

module.exports = function (nucleotides) {
  var type = ({}).toString.call(nucleotides);

  if (type != '[object String]') {
    throw new TypeError('Expected String but was given + ' + type);
  }

  return nucleotides.replace(/T/g, 'U');
};
