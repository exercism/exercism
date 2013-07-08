DNA = function(nucleotides) {

  this.nucleotides = nucleotides;

  this.hammingDistance = function(comparison) {
    var distance = 0;
    var calculationDistance = Math.min(this.nucleotides.length,comparison.length);

    for (var i = 0; i < calculationDistance; i++) {
      var currentNucleotide = this.nucleotides[i];
      var comparisonNucleotide = comparison[i];

      if (currentNucleotide != comparisonNucleotide) { distance++; }
    };

    return distance;
  };
};