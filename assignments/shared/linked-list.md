In simple-linked-list we created a push-down stack using a purely
functional linked list, but if we allow mutability and add another
pointer we can build a very fast deque data structure (Double-Ended
queue).

Deques have four fundamental operations (using Array terminology):

* push (insert value at back)
* unshift (insert value at front)
* pop (remove value at back)
* shift (remove value at front)

The difference between deque and Array performance is that a deque
implements all of these operations in constant time. Even clever
implemetations of Array will often have to copy the entire Array
in order to unshift.

Under the hood we'll use the same Element class from
simple-linked-list, but there should be a @next and @prev attributes
that are both writable. @prev should point to the previous Element in
the list.

To make the API usable, you'll use a Deque class as a proxy for this
list. There two good ways to implement Deque: maintain separate references to the
first and last Element, or maintain a reference to one of them and
ensure that the list is circular (first.prev.next == first).

To keep your implementation simple, the tests will not cover error
conditions. Specifically: pop or shift will never be called on an empty Deque.

In languages that do not have good support for mutability (such as
Elixir or Erlang), you may choose to implement a functional Deque
where shift and pop have amortized O(1) time. The simplest data structure
for this will have a pair of linked lists for the front and back,
where iteration order is front ++ reverse back.

Examples:

    deque = Deque.new
    deque.push(10)
    deque.push(20)
    deque.pop() #=> 20
    deque.push(30)
    deque.shift() #=> 10
    deque.unshift(40)
    deque.push(50)
    deque.shift() #=> 40
    deque.pop() #=> 50
    deque.shift() #=> 30
