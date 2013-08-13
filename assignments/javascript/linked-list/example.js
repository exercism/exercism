'use strict';

function elementAt(list, index) {
  var current = list.head;
  for (var i = 0; i < index; i++) {
    current = current.next;
  }
  return current;
}

function populateInitial(value) {
  /*jshint validthis:true */
  var currentTail = this.tail;
  this.tail = { value: value, next: null };
  if (currentTail) {
    currentTail.next = this.tail;
  }

  if (!this.head) {
    this.head = this.tail;
  }
}

function LinkedList(initialValues) {
  var list = { tail: null };
  initialValues.forEach(populateInitial, list);

  return {
    list: list,
    get head() {
      return list.head.value;
    },
    get tail() {
      return list.tail.value;
    },
    add: function (value) {
      var currentTail = this.list.tail;
      this.list.tail = { value: value, next: null };
      currentTail.next = this.list.tail;
    },
    valueAt: function (index) {
      return elementAt(this.list, index).value;
    },
    insert: function (index, value) {
      var previous = elementAt(this.list, index-1);
      var current = previous.next;
      previous.next = { value: value, next: current };
    },
    delete: function (index) {
      var previous = elementAt(this.list, index-1);
      previous.next = previous.next.next;
    }
  };
}

module.exports = LinkedList;
