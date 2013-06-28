DNA = function DNA(options){
  var dnaString, counts, nucleotidMatcher;

  nucleotideMatcher = /A+|C+|G+|T+/g;

  dnaString = options;
  dnaString = dnaString.match(nucleotideMatcher);
  counts = {'A': 0, 'T': 0, 'C': 0, 'G': 0}

  var _countAll = function(hash, subNucleotides){
    var letter = subNucleotides.charAt(0);
    hash[letter] = subNucleotides.length;
    return hash;
  };

  if(dnaString){
    counts = dnaString.reduce(_countAll, counts);
  }

  var _count = function(nucleotide) {
    return counts[nucleotide] || 0;
  };

  var _nucleotideCounts = counts;

  var API = {
    count: _count,
    nucleotideCounts: _nucleotideCounts
  }

  return API;

}
