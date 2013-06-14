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
