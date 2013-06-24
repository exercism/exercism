require('./secret_handshake');

describe("Secret Handshake", function() {
  it("1 is a wink", function() {
    var handshake = new SecretHandshake(1);
    expect(handshake.commands()).toEqual(["wink"])
  });

  it("10 is a double blink", function() {
    var handshake = new SecretHandshake(2);
    expect(handshake.commands()).toEqual(["double blink"]);
  });

  it("100 is close your eyes", function() {
    var handshake = new SecretHandshake(4);
    expect(handshake.commands()).toEqual(["close your eyes"]);
  });

  it("1000 is jump", function() {
    var handshake = new SecretHandshake(8);
    expect(handshake.commands()).toEqual(["jump"]);
  });

  it("11 is wink and double blink", function() {
    var handshake = new SecretHandshake(3);
    expect(handshake.commands()).toEqual(["wink","double blink"]);
  });

  it("10011 is double blink and wink", function() {
    var handshake = new SecretHandshake(19);
    expect(handshake.commands()).toEqual(["double blink","wink"]);
  });

  it("11111 is jump, close your eyes, double blink, and wink", function() {
    var handshake = new SecretHandshake(31);
    expect(handshake.commands()).toEqual(["jump","close your eyes","double blink","wink"]);
  });

  // it("text is an invalid secret handshake", function() {
  //   var handshake = new SecretHandshake("piggies");
  //   expect(handshake.commands()).toThrow("Error");
  // });
});