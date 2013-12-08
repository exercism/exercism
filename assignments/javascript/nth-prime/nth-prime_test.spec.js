var prime = require ('./nth-prime');

describe('Prime',function() {

  it('first',function(){
    expect(prime.nth(1)).toEqual(2);
  });

  xit('second',function(){
    expect(prime.nth(2)).toEqual(3);
  });

  xit('sixth',function(){
    expect(prime.nth(6)).toEqual(13);
  });

  xit('big prime',function(){
    expect(prime.nth(10001)).toEqual(104743);
  });

  xit('weird case',function() {
    expect( function () {
      prime.nth(0);
    }).toThrow(new Error("Prime is not possible"));
  });

});
