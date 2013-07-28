var DNA = require('./dna');

describe("DNA", function() {
  it("transcribes cytidine unchanged", function() {
    var dna = new DNA('C');
    expect(dna.toRNA()).toEqual('C');
  });

  xit("transcribes guanosine unchanged", function() {
    var dna = new DNA('G');
    expect(dna.toRNA()).toEqual('G');
  });

  xit("transcribes adenosine unchanged", function() {
    var dna = new DNA('A');
    expect(dna.toRNA()).toEqual('A');
  });

  xit("transcribes thymidine to uracil", function() {
    var dna = new DNA('T');
    expect(dna.toRNA()).toEqual('U');
  });

  xit("transcribes all occurrences of thymidine to uracil", function() {
    var dna = new DNA('ACGTGGTCTTAA');
    expect(dna.toRNA()).toEqual('ACGUGGUCUUAA');
  });

});
