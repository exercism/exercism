DNA = function DNA(options){
  var nucleotideCounts, nucleotidMatcher, validNucleotides;

  nucleotideMatcher = /A+|C+|G+|T+/g;
  validNucleotides = 'ACGTU';

  function _initialize(dnaString){
    var groupedNucleotides = dnaString.match(nucleotideMatcher);

    nucleotideCounts = {'A': 0, 'T': 0, 'C': 0, 'G': 0}

    if(groupedNucleotides){
      nucleotideCounts = groupedNucleotides.reduce(_countAll, nucleotideCounts);
    }

  }

  function _countAll(hash, subNucleotides){
    var letter = subNucleotides.charAt(0);
    hash[letter] = hash[letter]+subNucleotides.length;
    return hash;
  }

  function _isInvalidNucleotide(nucleotide){
    return validNucleotides.indexOf(nucleotide) < 0;
  }

  function _count(nucleotide) {
    if(_isInvalidNucleotide(nucleotide)) {
      throw new Error('Invalid Nucleotide');
    }
    return nucleotideCounts[nucleotide] || 0;
  }

  _initialize(options);

  var API = {
    count: _count,
    nucleotideCounts: nucleotideCounts
  }

  return API;

}
