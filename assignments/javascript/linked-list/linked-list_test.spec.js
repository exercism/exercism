var LinkedList = require('./example');

function rangeArray(min, max) {
  var array = [];
  for (var i = min; i <= max; i++) {
    array.push(i);
  }
  return array;
}

describe('LinkedList Proxy', function () {
  var list = new LinkedList(rangeArray(0, 100));

  it('head', function () {
    expect(list.head).toBe(0);
  });

  it('tail', function () {
    expect(list.tail).toBe(100);
  });

  it('can add a new element', function () {
    list.add(101);
    expect(list.tail).toBe(101);
  });

  it('can access a specifict element', function () {
    expect(list.valueAt(51)).toBe(51);
  });

  it('first index', function () {
    expect(list.valueAt(0)).toBe(list.head);
  });

  it('insert', function () {
    list.insert(52, 52.5);
    expect(list.valueAt(52)).toBe(52.5);
  });

  it('delete', function () {
    list.delete(52);
    expect(list.valueAt(52)).toBe(52);
  });

});

describe('LinkedList', function () {
  var ll = new LinkedList([1]);
  var head = ll.list.head;

  it('head is an object', function () {
    expect(typeof head).toBe('object');
  });

  it('head value', function () {
    expect(head.value).toBe(1);
  });

  it('add next', function () {
    head.next = { value: 2, next: null };
    expect(head.next).toBeDefined();
    expect(typeof head.next).toBe('object');
    expect(head.next.value).toBe(2);
  });

});

describe('LinkedList range', function () {
  var ll = new LinkedList(rangeArray(1, 10));
  var head = ll.list.head;

  it('head next', function () {
    expect(head.next.value).toBe(2);
  });

  it('10 deep', function () {
    expect(head.next.next.next.next.next.next.next.next.next.value).toBe(10);
  });

});