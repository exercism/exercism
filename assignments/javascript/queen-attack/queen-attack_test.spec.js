require('./queens');


describe("Queens", function() {
  it("has the correct default positions", function() {
    var queens = new Queens;
    expect(queens.white).toEqual([0, 3]);
    expect(queens.black).toEqual([7, 3]);
  });

  it("initialized with specific placement", function() {
    var queens = new Queens({white: [3,7], black: [6,1]});
    expect(queens.white).toEqual([3, 7]);
    expect(queens.black).toEqual([6, 1]);
  });

  it("cannot occupy the same space", function() {
    var positioning = {white: [2,4], black: [2,4]};

    try {
      var queens = new Queens(positioning);
    } catch(error) {
      expect(error).toEqual("Queens cannot share the same space");
    }

  });

  it("toString representation", function() {
    var positioning = {white: [2, 4], black: [6, 6]};
    var queens = new Queens(positioning);
    var board = "O O O O O O O O\n\
O O O O O O O O\n\
O O O O W O O O\n\
O O O O O O O O\n\
O O O O O O O O\n\
O O O O O O O O\n\
O O O O O O B O\n\
O O O O O O O O\n\
"
    expect(queens.toString()).toEqual(board);

  });

  it("queens cannot attack", function() {
    var queens = new Queens({ white: [2,3], black: [4,7] });
    expect(queens.canAttack()).toEqual(false);
  });

  it("queens can attack when they are on the same row", function() {
    var queens = new Queens({ white: [2,4], black: [2,7] });
    expect(queens.canAttack()).toEqual(true);
  });

  it("queens can attack when they are on the same column", function() {
    var queens = new Queens({ white: [5,4], black: [2,4] });
    expect(queens.canAttack()).toEqual(true);
  });

  it("queens can attack diagonally", function() {
    var queens = new Queens({ white: [1, 1], black: [6, 6] });
    expect(queens.canAttack()).toEqual(true);
  });

  it("queens can attack another diagonally", function() {
    var queens = new Queens({ white: [0, 6], black: [1, 7] });
    expect(queens.canAttack()).toEqual(true);
  });

  it("queens can attack yet another diagonally", function() {
    var queens = new Queens({ white: [4, 1], black: [6, 3] });
    expect(queens.canAttack()).toEqual(true);
  });

});