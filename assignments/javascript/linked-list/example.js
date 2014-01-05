'use strict';

function Node(value, next, prev) {
  this.value = value;
  this.next = next || this;
  this.prev = prev || this;
}

function LinkedList() {
  this._front = null;
}

LinkedList.prototype.push = function LinkedList_push(value) {
  if (this._front === null) {
    this._front = new Node(value);
  } else {
    var back = this._front.prev;
    var n = new Node(value, this._front, back);
    back.next = n;
    this._front.prev = n;
  }
};

LinkedList.prototype.unshift = function LinkedList_unshift(value) {
  this.push(value);
  this._front = this._front.prev;
};

LinkedList.prototype.pop = function LinkedList_pop() {
  if (this._front === null) {return undefined};
  this._front = this._front.prev;
  return this.shift();
};

LinkedList.prototype.shift = function LinkedList_shift() {
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

LinkedList.prototype.count = function() {
  if (this._front === null) {
    return 0;
  } else if (this._front.next === this._front) {
    return 1;
  } else {
    this._front.next = this._front.next.next;
    return this.count() + 1;
  }
};

LinkedList.prototype.delete = function(match) {
  if (this._front.next === this._front && this._front.value === match) {
    this._front = null;
  } else if (this._front.next.value === match) {
    this._front.next = this._front.next.next;
  } else {
    this._front = this._front.next;
    return this.delete(match);
  }
};

module.exports = LinkedList;
