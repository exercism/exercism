A [Domain Specific Language
(DSL)](https://en.wikipedia.org/wiki/Domain-specific_language) is a small
language optimized for a specific domain.

For example the dot language of [Graphviz](http://graphviz.org) allows you to
write a textual description of a graph which is then transformed into a picture
by one of the graphviz tools (such as `dot`). A simple graph looks like this:

    graph {
        graph [bgcolor="yellow"]
        a [color="red"]
        b [color="blue"]
        a -- b [color="green"]
    }

Putting this in a file `example.dot` and running `dot example.dot -T png -o
example.png` creates an image `example.png` with red and blue circle connected
by a green line on a yellow background.

Create a DSL similar to the dot language. 
