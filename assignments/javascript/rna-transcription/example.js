DNA = function(nucleotides) {
  this.nucleotides = nucleotides;

  this.toRNA = function() {
    return this.nucleotides.replace(/T/g,'U');
  };
}