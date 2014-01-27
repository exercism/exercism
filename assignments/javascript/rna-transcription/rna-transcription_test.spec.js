var toRna = require('./rna-transcription');

describe("toRna()", function() {
  it("transcribes cytidine to guanosine", function() {
    expect(toRna('C')).toEqual('G');
  });

  xit("transcribes guanosine to cytidine", function() {
    expect(toRna('G')).toEqual('C');
  });

  xit("transcribes adenosine to uracil", function() {
    expect(toRna('A')).toEqual('U');
  });

  xit("transcribes thymidine to adenosine", function() {
    expect(toRna('T')).toEqual('A');
  });

  xit("transcribes all dna nucleotides to their rna complements", function() {
    expect(toRna('ACGTGGTCTTAA'))
        .toEqual('UGCACCAGAAUU');
  });
});
