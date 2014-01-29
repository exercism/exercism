var CustomSet = require('./custom-set');

describe('CustomSet', function() {

  it('can delete elements', function(){
    var expected = new CustomSet([1, 3]);
    var actual = new CustomSet([3, 2, 1]).delete(2);
    expect(actual.eql(expected)).toBe(true);

    var expected2 = new CustomSet([1, 2, 3]);
    var actual2 = new CustomSet([3, 2, 1]).delete(4);
    expect(actual2.eql(expected2)).toBe(true);
  });

  xit('can check for difference', function(){
    var expected = new CustomSet([1, 3]);
    var actual = new CustomSet([3, 2, 1]).difference(new CustomSet([2, 4]));
    expect(actual.eql(expected)).toBe(true);
    var expected2 = new CustomSet([1, 2, 3]);
    var actual2 = new CustomSet([1, 2, 3]).difference(new CustomSet([4]));
    expect(actual2.eql(expected2)).toBe(true);
  });

  xit('can test disjoint', function() {
    var actual = new CustomSet([1, 2]).disjoint(new CustomSet([3, 4]));
    expect(actual).toBe(true);
    var actual2 = new CustomSet([1, 2]).disjoint(new CustomSet([2, 3]));
    expect(actual2).toBe(false);
    var actual3 = new CustomSet().disjoint(new CustomSet());
    expect(actual3).toBe(false);
  });

  xit('can be emptied', function() {
    var actual = new CustomSet([1, 2]).empty();
    var expected = new CustomSet();
    expect(actual.eql(expected)).toBe(true);
    var actual2 = new CustomSet().empty();
    var expected2 = new CustomSet();
    expect(actual2.eql(expected2)).toBe(true);
  });

  xit('can check for intersection', function() {
    var actual = new CustomSet(["a", "b", "c"]).intersection(new CustomSet(["a", "c", "d"]));
    var expected = new CustomSet(["a", "c"]);
    expect(actual.eql(expected)).toBe(true);

    var actual2 = new CustomSet([1, 2, 3]).intersection(new CustomSet([3, 5, 4]));
    var expected2 = new CustomSet([3]);
    expect(actual2.eql(expected2)).toBe(true);
  });

  xit('can test for a member', function() {
    var actual = new CustomSet([1, 2, 3]).member(2);
    expect(actual).toBe(true);
    var actual2 = new CustomSet([1, 2, 3]).member(4);
    expect(actual2).toBe(false);
  });

  xit('can add a member with put', function() {
    var actual = new CustomSet([1, 2, 4]).put(3);
    var expected = new CustomSet([1, 2, 3, 4]);
    expect(actual.eql(expected)).toBe(true);
    var actual2 = new CustomSet([1, 2, 3]).put(3);
    var expected2 = new CustomSet([1, 2, 3]);
    expect(actual2.eql(expected2)).toBe(true);
  });

  xit('knows its size', function() {
    var actual = new CustomSet().size();
    expect(actual).toBe(0);
    var actual2 = new CustomSet([1, 2, 3]).size();
    expect(actual2).toBe(3);
    var actual3 = new CustomSet([1, 2, 3, 2]).size();
    expect(actual3).toBe(3);
  });

  xit('can test for subsets', function() {
    var actual = new CustomSet([1, 2, 3]).subset(new CustomSet([1, 2, 3]));
    expect(actual).toBe(true);
    var actual2 = new CustomSet([4, 1, 2, 3]).subset(new CustomSet([1, 2, 3]));
    expect(actual2).toBe(true);
    var actual3 = new CustomSet([4, 1, 3]).subset(new CustomSet([1, 2, 3]));
    expect(actual3).toBe(false);
    var actual4 = new CustomSet([4, 1, 3]).subset(new CustomSet());
    expect(actual4).toBe(true);
    var actual5 = new CustomSet().subset(new CustomSet());
    expect(actual5).toBe(true);
  });

  xit('can give back a list', function() {
    var actual = new CustomSet().toList();
    var expected = [];
    expect(actual.sort()).toEqual(expected);
    var actual2 = new CustomSet([3, 1, 2]).toList();
    var expected2 = [1, 2, 3];
    expect(actual2.sort()).toEqual(expected2);
    var actual3 = new CustomSet([3, 1, 2, 1]).toList();
    var expected3 = [1, 2, 3];
    expect(actual3.sort()).toEqual(expected3);
  });

  xit('can test for union', function() {
    var actual = new CustomSet([1, 3]).union(new CustomSet([2]));
    var expected = new CustomSet([3, 2, 1]);
    expect(actual.eql(expected)).toBe(true);
    var actual2 = new CustomSet([1, 3]).union(new CustomSet([2, 3]));
    var expected2 = new CustomSet([3, 2, 1]);
    expect(actual2.eql(expected2)).toBe(true);
    var actual3 = new CustomSet([1, 3]).union(new CustomSet());
    var expected3 = new CustomSet([3, 1]);
    expect(actual3.eql(expected3)).toBe(true);
    var actual4 = new CustomSet().union(new CustomSet());
    var expected4 = new CustomSet();
    expect(actual4.eql(expected4)).toBe(true);
  });

});
