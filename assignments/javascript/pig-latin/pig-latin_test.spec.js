var pigLatin = require('./pig-latin');

describe('pigLatin', function () {

  it('translates a word beginning with a', function () {
    expect(pigLatin.translate('apple')).toEqual('appleay');
  });

  xit('translates a word beginning with e', function () {
    expect(pigLatin.translate('ear')).toEqual('earay');
  });

  xit('translates a word beginning with p', function () {
    expect(pigLatin.translate('pig')).toEqual('igpay');
  });

  xit('translates a word beginning with k', function () {
    expect(pigLatin.translate('koala')).toEqual('oalakay');
  });

  xit('translates a word beginning with ch', function () {
    expect(pigLatin.translate('chair')).toEqual('airchay');
  });

  xit('translates a word beginning with qu', function () {
    expect(pigLatin.translate('queen')).toEqual('eenquay');
  });

  xit('translates a word with a consonant preceding qu', function () {
    expect(pigLatin.translate('square')).toEqual('aresquay');
  });

  xit('translates a word beginning with th', function () {
    expect(pigLatin.translate('therapy')).toEqual('erapythay');
  });

  xit('translates a word beginning with thr', function () {
    expect(pigLatin.translate('thrush')).toEqual('ushthray');
  });

  xit('translates a word beginning with sch', function () {
    expect(pigLatin.translate('school')).toEqual('oolschay');
  });

  xit('translates a phrase', function () {
    expect(pigLatin.translate('quick fast run'))
      .toEqual('ickquay astfay unray');
  });

});
