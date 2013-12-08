var primeFactors = require('./prime-factors');

describe('primeFactors', function() {

  it('returns an empty array for 1', function() {
    expect(primeFactors.for(1)).toEqual([]);
  });

  xit('factors 2', function() {
    expect(primeFactors.for(2)).toEqual([2]);
  });

  xit('factors 3', function() {
    expect(primeFactors.for(3)).toEqual([3]);
  });

  xit('factors 4', function() {
    expect(primeFactors.for(4)).toEqual([2, 2]);
  });

  xit('factors 6', function() {
    expect(primeFactors.for(6)).toEqual([2, 3]);
  });

  xit('factors 8', function() {
    expect(primeFactors.for(8)).toEqual([2, 2, 2]);
  });

  xit('factors 9', function() {
    expect(primeFactors.for(9)).toEqual([3, 3]);
  });

  xit('factors 27', function() {
    expect(primeFactors.for(27)).toEqual([3, 3, 3]);
  });

  xit('factors 625', function() {
    expect(primeFactors.for(625)).toEqual([5, 5, 5, 5]);
  });

  xit('factors 901255', function() {
    expect(primeFactors.for(901255)).toEqual([5, 17, 23, 461]);
  });

  xit('factors 93819012551', function() {
    expect(primeFactors.for(93819012551)).toEqual([11, 9539, 894119]);
  });

});
