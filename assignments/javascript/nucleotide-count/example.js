(function() {
  'use strict';

  function DNA(dnaString){
    var splitDNA = dnaString.split('');

    this.nucleotideCounts = { A : 0, T : 0, C : 0, G : 0 };
    this.validNucleotides = 'ATCGU';

    splitDNA.reduce(this.countAll, this.nucleotideCounts);
  }

  DNA.prototype.countAll = function countAll(nucleotideCounts, nucleotide) {
    nucleotideCounts[nucleotide] = nucleotideCounts[nucleotide] + 1;
    return nucleotideCounts;
  };

  DNA.prototype._isValidNucleotide = function _isValidNucleotide(nucleotide) {
    return this.validNucleotides.indexOf(nucleotide) >= 0;
  };

  DNA.prototype.count = function count(nucleotide) {
    if(this._isValidNucleotide(nucleotide)) {
      return this.nucleotideCounts[nucleotide] || 0;
    } else {
      throw new Error("Invalid Nucleotide");
    }
  };

  module.exports = DNA;
})();