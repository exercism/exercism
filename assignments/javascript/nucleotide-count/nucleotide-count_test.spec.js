require('./nucleotide');

describe('DNA', function() {

  it('has no nucleotides', function(){
    var expected = {'A': 0, 'T': 0, 'C': 0, 'G': 0}
    var dna = new DNA('');
    expect(dna.nucleotideCounts).toEqual(expected);
  });

  it('has no adenosine', function(){
    var dna = new DNA('');
    expect(dna.count('A')).toEqual(0);
  });

  it('repetitive cytidine gets counts', function(){
    var dna = new DNA('CCCCC');
    expect(dna.count('C')).toEqual(5);
  })

  it('repetitive sequence has only guanosine', function(){
    var dna = new DNA('GGGGGGGG');
    var expected = {'A': 0, 'T': 0, 'C': 0, 'G': 8}
    expect(dna.nucleotideCounts).toEqual(expected);
  });

  it('counts only thymidine', function(){
    var dna = new DNA('GGGGTAACCCGG');
    expect(dna.count('T')).toEqual(1);
  });

  it('counts a nucleotide only once', function(){
    var dna = new DNA('GGTTGG');
    dna.count('T');
    expect(dna.count('T')).toEqual(2);
  });

  it('has no uracil', function(){
    var dna = new DNA('GGTTGG');
    expect(dna.count('U')).toEqual(0);
  });

  it('validates nucleotides', function(){
      var dna = new DNA('GGTTGG');
      expect(function(){dna.count('X')}).toThrow(new Error("Invalid Nucleotide"));
  });

  it('counts all nucleotides', function(){
    var dna = new DNA("AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC");
    var expected = {'A': 20, 'T': 21, 'G': 17, 'C': 12 }
    expect(dna.nucleotideCounts).toEqual(expected);
  });

});
