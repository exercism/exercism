DNA = function DNA(dnaString){
  var dnaLength = dnaString.length,
      splitDNA = dnaString.split('');

  function _countAll(count, nucleotide) {
    count[nucleotide] = count[nucleotide]+1
    return count;
  };

  this.nucleotideCounts = {'A': 0, 'T': 0, 'C': 0, 'G': 0};
  this.validNucleotides = 'ATCGU';

  this.isValidNucleotide = function isValidNucleotide(nucleotide) {
    return this.validNucleotides.indexOf(nucleotide) >= 0
  };

  splitDNA.reduce(_countAll, this.nucleotideCounts);

}

DNA.prototype.count = function count(nucleotide) {
  if(this.isValidNucleotide(nucleotide)) {
    return this.nucleotideCounts[nucleotide] || 0
  } else {
    throw new Error("Invalid Nucleotide");
  }
}
