var Bst = require('./example');

function recordAllData(bst) {
  var out = [];

  bst.each(function (data) { out.push(data); });

  return out;
}

describe('BinarySearchTree', function() {

  it('data is retained', function() {
    expect(4).toEqual(new Bst(4).data);
  });

  xit('inserting less', function() {
    var four;

    four = new Bst(4);
    four.insert(2);

    expect(4).toEqual(four.data);
    expect(2).toEqual(four.left.data);
  });

  xit('inserting same', function() {
    var four;

    four = new Bst(4);
    four.insert(4);

    expect(4).toEqual(four.data);
    expect(4).toEqual(four.left.data);
  });

  xit('inserting right', function() {
    var four;

    four = new Bst(4);
    four.insert(5);

    expect(4).toEqual(four.data);
    expect(5).toEqual(four.right.data);
  });

  xit('complex tree', function() {
    var four;

    four = new Bst(4);
    four.insert(2);
    four.insert(6);
    four.insert(1);
    four.insert(3);
    four.insert(7);
    four.insert(5);

    expect(4).toEqual(four.data);
    expect(2).toEqual(four.left.data);
    expect(1).toEqual(four.left.left.data);
    expect(3).toEqual(four.left.right.data);
    expect(6).toEqual(four.right.data);
    expect(5).toEqual(four.right.left.data);
    expect(7).toEqual(four.right.right.data);
  });

  xit('iterating one element', function() {
    expect([4]).toEqual(recordAllData(new Bst(4)));
  });

  xit('iterating over smaller element', function() {
    var four;

    four = new Bst(4);
    four.insert(2);

    expect([2, 4]).toEqual(recordAllData(four));
  });

  xit('iterating over larger element', function() {
    var four;

    four = new Bst(4);
    four.insert(5);

    expect([4, 5]).toEqual(recordAllData(four));
  });

  xit('iterating over complex tree', function() {
    var four;

    four = new Bst(4);
    four.insert(2);
    four.insert(1);
    four.insert(3);
    four.insert(6);
    four.insert(7);
    four.insert(5);

    expect([1, 2, 3, 4, 5, 6, 7]).toEqual(recordAllData(four));
  });

});
