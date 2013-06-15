## Step 1

The linked list is a fundamental data structure in computer science so it's pretty important that all students who seek jobs at the larger companies know some data structures for the interviews. In Ruby we don't actually use linked lists very often, they come from a time when all Arrays needed to be sequentially located in memory which is not the case in the post-modern languages (though we still try at the VM level for performance reasons).

As a first take, lets create a linked list with just Element objects containing the range (1..10). Next we'll use the Proxy pattern to make sure that things are done correctly and make it feel Rubyish.

Examples:
  head = linked_list([1])
  head #=> <Element @datum=1, @next=nil>
  head.next = Element.new(2)
  head #=> <Element @datum=1, @next=<Element...>>
  head.datum #=> 1
  head.next.datum #=> 2
  head = linked_list((1..10).to_a)
  head.next.next.next.next.next.next.next.next.next.next.datum #=> 10

## Step 2

Last time we created a linked list manually and it probably felt pretty silly. Why in the world would you ever use a linked list?

Linked lists have one great performance feature: it's trivial to add things in the middle of the array. Take one moment to imagine what you would have to do to insert a value in the middle of an array in Ruby (only using a loop and []).

With linked lists on the other hand, all we have to do is find the right element, change the value for @next, and we've inserted an element in the middle. The tradeoff here, is that it's difficult to iterate over a linked list. We have to ask who is the next element each time.

This time, let's use the Proxy pattern to make things a little easier to manage.

Examples:
  list = LinkedList.new((0..100).to_a)
  list.add(999)
  list.tail #=> 999

  list.index(51) #=> 51
  list.index(52) #=> 52
  list.index(53) #=> 53
  list.insert(52, 52.5)
  list.index(51) #=> 51
  list.index(52) #=> 52.5
  list.index(53) #=> 52
  list.delete(52)
  list.index(51) #=> 51
  list.index(52) #=> 52
  list.index(53) #=> 53
