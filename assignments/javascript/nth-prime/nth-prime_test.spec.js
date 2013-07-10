require ('./prime');

describe('Prime',function() {

  it('first',function(){
    var prime = Prime.nth(1);
    expect(prime).toEqual(2);
  });

  xit('second',function(){
    var prime = Prime.nth(2);
    expect(prime).toEqual(3);
  });

  xit('sixth',function(){
    var prime = Prime.nth(6);
    expect(prime).toEqual(13);
  });

  xit('big prime',function(){
    var prime = Prime.nth(10001);
    expect(prime).toEqual(104743);
  });

  xit('weird case',function() {
    try {
      Prime.nth(0);
    } catch(error) {
      expect(error).toEqual("Prime is not possible");
    }

  });

});