var toRna = require('./rna-transcription');

describe("toRna()", function() {
  it("transcribes cytidine unchanged", function() {
    expect(toRna('C')).toEqual('C');
  });

  xit("transcribes guanosine unchanged", function() {
    expect(toRna('G')).toEqual('G');
  });

  xit("transcribes adenosine unchanged", function() {
    expect(toRna('A')).toEqual('A');
  });

  xit("transcribes thymidine to uracil", function() {
    expect(toRna('T')).toEqual('U');
  });

  xit("transcribes all occurrences of thymidine to uracil", function() {
    expect(toRna('ACGTGGTCTTAA')).toEqual('ACGUGGUCUUAA');
  });
});
