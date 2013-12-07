var atbash = require('./atbash-cipher');

describe("encode", function() {

  it("encodes no", function() {
    expect(atbash.encode('no')).toEqual('ml');
  });

  xit("encodes yes", function() {
    expect(atbash.encode('yes')).toEqual('bvh');
  });

  xit("encodes OMG", function() {
    expect(atbash.encode('OMG')).toEqual('lnt');
  });

  xit("encodes O M G", function() {
    expect(atbash.encode('O M G')).toEqual('lnt');
  });

  xit("encodes long words", function() {
    expect(atbash.encode('mindblowingly')).toEqual('nrmwy oldrm tob');
  });

  xit("encodes numbers", function() {
    expect(atbash.encode('Testing, 1 2 3, testing.'))
      .toEqual('gvhgr mt123 gvhgr mt');
  });

  xit("encodes sentences", function() {
    expect(atbash.encode('Truth is fiction.')).toEqual('gifgs rhurx grlm');
  });

  xit("encodes all the things", function() {
    expect(atbash.encode('The quick brown fox jumps over the lazy dog.'))
      .toEqual('gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt');
  });

});
