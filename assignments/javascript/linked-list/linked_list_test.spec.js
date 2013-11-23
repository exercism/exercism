var Deque = require('./example');

describe('Deque', function () {
  it('push/pop', function () {
    var deque = new Deque();
    deque.push(10);
    deque.push(20);
    expect(deque.pop()).toBe(20);
    expect(deque.pop()).toBe(10);
  });
  it('push/shift', function () {
    var deque = new Deque();
    deque.push(10);
    deque.push(20);
    expect(deque.shift()).toBe(10);
    expect(deque.shift()).toBe(20);
  });
  it('unshift/shift', function () {
    var deque = new Deque();
    deque.unshift(10);
    deque.unshift(20);
    expect(deque.shift()).toBe(20);
    expect(deque.shift()).toBe(10);
  });
  it('unshift/pop', function () {
    var deque = new Deque();
    deque.unshift(10);
    deque.unshift(20);
    expect(deque.pop()).toBe(10);
    expect(deque.pop()).toBe(20);
  });
  it('example', function () {
    var deque = new Deque();
    deque.push(10);
    deque.push(20);
    expect(deque.pop()).toBe(20);
    deque.push(30);
    expect(deque.shift()).toBe(10);
    deque.unshift(40);
    deque.push(50);
    expect(deque.shift()).toBe(40);
    expect(deque.pop()).toBe(50);
    expect(deque.shift()).toBe(30);
  });
});
