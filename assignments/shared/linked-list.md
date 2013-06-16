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
