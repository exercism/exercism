var Cipher = require('./cipher');

describe('Random key cipher', function () {
  var cipher = new Cipher();

  it('has a key made of letters', function () {
    expect(cipher.key).toMatch(/[a-z]+/);
  });

  // Here we take advantage of the fact that plaintext of "aaa..."
  // outputs the key. This is a critical problem with shift ciphers, some
  // characters will always output the key verbatim.  
  xit('can encode', function () {
    expect(cipher.encode('aaaaaaaaaa')).toEqual(cipher.key.substr(0,10));
  });

  xit('can decode', function () {
    expect(cipher.decode(cipher.key.substr(0,10))).toEqual('aaaaaaaaaa');
  });

  xit('is reversible', function () {
    var plaintext = 'abcdefghij';
    expect(cipher.decode(cipher.encode(plaintext))).toEqual(plaintext);
  });

});

describe('Incorrect key cipher', function () {

  xit('throws an error with an all caps key', function () {
    expect( function () {
      new Cipher("ABCDEF");
    }).toThrow(new Error("Bad key"));
  });

  xit('throws an error with a numeric key', function () {
    expect( function () {
      new Cipher("12345");
    }).toThrow(new Error("Bad key"));
  });

  xit('throws an error with an empty key', function () {
    expect( function () {
      new Cipher("");
    }).toThrow(new Error("Bad key"));
  });

});

describe('Substitution cipher', function () {
  var key = 'abcdefghij';
  var cipher = new Cipher(key);

  xit('keeps the submitted key', function () {
    expect(cipher.key).toEqual(key);
  });

  xit('can encode', function () {
    expect(cipher.encode('aaaaaaaaaa')).toEqual('abcdefghij');
  });

  xit('can decode', function () {
    expect(cipher.decode('abcdefghij')).toEqual('aaaaaaaaaa');
  });

  xit('is reversible', function () {
    expect(cipher.decode(cipher.encode('abcdefghij'))).toEqual('abcdefghij');
  });

  xit(': double shift encode', function () {
    expect(new Cipher('iamapandabear').encode('iamapandabear'))
      .toEqual('qayaeaagaciai');
  });

  xit('can wrap', function () {
    expect(cipher.encode('zzzzzzzzzz')).toEqual('zabcdefghi');
  });

});