var compute = require('./hamming').compute;

describe('Hamming', function () {

  it('no difference between identical strands', function () {
    expect(compute('A', 'A')).toEqual(0);
  });

  xit('complete hamming distance of for single nucleotide strand', function () {
    expect(compute('A','G')).toEqual(1);
  });

  xit('complete hamming distance of for small strand', function () {
    expect(compute('AG','CT')).toEqual(2);
  });

  xit('small hamming distance', function () {
    expect(compute('AT','CT')).toEqual(1);
  });

  xit('small hamming distance in longer strand', function () {
    expect(compute('GGACG', 'GGTCG')).toEqual(1);
  });

  xit('ignores extra length on first strand when longer', function () {
    expect(compute('AAAG', 'AAA')).toEqual(0);
  });

  xit('ignores extra length on other strand when longer', function () {
    expect(compute('AAA', 'AAAG')).toEqual(0);
  });

  xit('large hamming distance', function () {
    expect(compute('GATACA', 'GCATAA')).toEqual(4);
  });

  xit('hamming distance in very long strand', function () {
    expect(compute('GGACGGATTCTG', 'AGGACGGATTCT')).toEqual(9);
  });

});

