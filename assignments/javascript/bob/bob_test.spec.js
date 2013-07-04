require('./bob');

describe("Bob", function() {
  var bob = new Bob();

  it("stating something", function() {
    var result = bob.hey('Tom-ay-to, tom-aaaah-to.');
    expect(result).toEqual('Whatever');
  });

  xit("shouting", function() {
    var result = bob.hey('WATCH OUT!');
    expect(result).toEqual('Woah, chill out!');
  });

  it("asking a question", function() {
    var result = bob.hey('Does this cryogenic chamber make me look fat?');
    expect(result).toEqual('Sure');
  });

  it("talking forcefully", function() {
    var result = bob.hey("Let's go make out behind the gym!");
    expect(result).toEqual('Whatever');
  });

  it("shouting numbers", function() {
    var result = bob.hey('1, 2, 3 GO!');
    expect(result).toEqual('Woah, chill out!');
  });

  it("shouting with special characters", function() {
    var result = bob.hey('ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!');
    expect(result).toEqual('Woah, chill out!');
  });

  it("silence", function() {
    var result = bob.hey('');
    expect(result).toEqual('Fine, be that way.');
  });

});
