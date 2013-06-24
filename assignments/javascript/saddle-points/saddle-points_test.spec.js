require("./matrix");

describe("Matrix", function() {

  it("extracts a row", function() {
    var matrix = new Matrix("1 2\n10 20");
    expect(matrix.rows[0]).toEqual([1,2]);
  });

  it("extracts other row", function() {
    var matrix = new Matrix("9 8 7\n19 18 17");
    expect(matrix.rows[1]).toEqual([19, 18, 17]);
  });

  it("extracts a column", function() {
    var matrix = new Matrix("1 2 3\n4 5 6\n7 8 9\n 8 7 6");
    expect(matrix.columns[0]).toEqual([1, 4, 7, 8]);
  });

  it("extracts another column", function() {
    var matrix = new Matrix("89 1903 3\n18 3 1\n9 4 800");
    expect(matrix.columns[1]).toEqual([1903, 3, 4]);
  });

  it("no saddle point", function() {
    var matrix = new Matrix("2 1\n1 2");
    expect(matrix.saddlePoints).toEqual([]);
  });

  it("a saddle point", function() {
    var matrix = new Matrix("1 2\n3 4");
    expect(matrix.saddlePoints).toEqual([[1,0]]);
  });

  it("another saddle point", function() {
    var matrix = new Matrix("18 3 39 19 91\n38 10 8 77 320\n3 4 8 6 7");
    expect(matrix.saddlePoints).toEqual([[2,2]]);
  });

  it("multiple saddle points", function() {
    var matrix = new Matrix("4 5 4\n3 5 5\n1 5 4");
    expect(matrix.saddlePoints).toEqual([[1, 0], [1, 1], [1, 2]]);
  });
});