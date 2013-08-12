'use strict';

module.exports = LinkedList;

function LinkedList(initialValues) {
  var list = { head: null, tail: null };
  initialValues.forEach(function (value) {
    var currentTail = list.tail;
    list.tail = { value: value, next: null };
    if (currentTail) {
      currentTail.next = list.tail;
    }

    if (!list.head) {
      list.head = list.tail;
    }
  });

  return {
    list: list,
    get head() {
      return this.list.head.value;
    },
    get tail() {
      return this.list.tail.value;
    },
    add: function (value) {
      var currentTail = this.list.tail;
      this.list.tail = { value: value, next: null };
      currentTail.next = this.list.tail;
    },
    elementAt: function (index) {
      var current = this.list.head;
      for (var i = 0; i < index; i++) {
        current = current.next;
      }
      return current;
    },
    valueAt: function (index) {
      return this.elementAt(index).value;
    },
    insert: function (index, value) {
      var previous = this.elementAt(index-1);
      console.log('previous: ' + previous);
      var current = previous.next;
      console.log('current: ' + current);
      previous.next = { value: value, next: current };
      console.log('previous: ' + previous);
    },
    delete: function (index) {
      var previous = this.elementAt(index-1);
      previous.next = previous.next.next;
    }
  };
}
