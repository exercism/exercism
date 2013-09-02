The linked list is a fundamental data structure in computer science, often used in the implementation of other data structures. They're pervasive in functional programming languages, such as Clojure, Erlang, or Haskell, but far less common in imperative languages such as Ruby or Python.

The simplest kind of linked list is an immutable linked list, which is the kind that's built-in to these functional programming languages. Immutable (or more specifically: persistent) data structures can be copied in constant time (since a reference is equivalent to a copy), and can save loads of time and memory for certain use cases because structure can be shared between versions of the data structure.

This variant of linked lists is often used to represent sequences or push-down stacks (also called a LIFO stack; Last In, First Out).

As a first take, lets create a persistent linked list with just Element objects containing the range (1..10), and provide functions to reverse a linked list and convert to and from arrays.

When implementing this in a language with built-in linked lists, implement your own abstract data type.

Examples (Ruby):

    Element.to_a(nil) #=> []
    Element.from_a([]) #=> nil
    Element.reverse(nil) #=> nil
    one = Element.new(1, nil)
    one #=> <Element @datum=1, @next=nil>
    one.datum #=> 1
    one.next #=> nil
    two = Element.new(2, one)
    two #=> <Element @datum=2, @next=<Element @datum=1 @next=nil>>
    Element.to_a(two) #=> [2, 1]
    Element.reverse(two) #=> <Element @datum=1 @next=<Element @datum=2 @next=nil>>
    range = Element.from_a(1..10)
    range.datum #=> 1
    range.next.next.next.next.next.next.next.next.next.next.datum #=> 10
