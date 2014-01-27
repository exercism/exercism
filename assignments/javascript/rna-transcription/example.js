"use strict";

module.exports = toRna;

var dnaToRna = {
  G: "C",
  C: "G",
  T: "A",
  A: "U"
};

function toRna(dna) {
  return dna.replace(/./g, function(dnaNucleotide) {
    return dnaToRna[dnaNucleotide];
  });
}
