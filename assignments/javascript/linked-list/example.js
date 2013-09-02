'use strict';

function Node(value, next, prev) {
  this.value = value;
  this.next = next || this;
  this.prev = prev || this;
}

function Deque() {
  this._front = null;
}

Deque.prototype.push = function Deque_push(value) {
  if (this._front === null) {
    this._front = new Node(value);
  } else {
    var back = this._front.prev;
    var n = new Node(value, this._front, back);
    back.next = n;
    this._front.prev = n;
  }
};

Deque.prototype.unshift = function Deque_unshift(value) {
  this.push(value);
  this._front = this._front.prev;
};

Deque.prototype.pop = function Deque_pop() {
  this._front = this._front.prev;
  return this.shift();
};

Deque.prototype.shift = function Deque_shift() {
  var value = this._front.value;
  var front = this._front.next;
  var back = this._front.prev;
  if (front === this._front) {
    this._front = null;
  } else {
    front.prev = back;
    back.next = front;
    this._front = front;
  }
  return value;
};

module.exports = Deque;
