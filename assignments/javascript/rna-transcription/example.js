(function() {
  'use strict';

  function DNA(nucleotides) {
    this.nucleotides = nucleotides;
  }

  DNA.prototype.toRNA = function() {
    return this.nucleotides.replace(/T/g,'U');
  };

  module.exports = DNA;
})();