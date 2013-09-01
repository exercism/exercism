module.exports = class BinarySearchTree

  constructor: (@data) ->
    @left  = undefined;
    @right = undefined;

  insert: (value) ->
    if value <= @data
      @insertLeft value
    else
      @insertRight value

  insertLeft: (value) ->
    if not @left
      @left = new BinarySearchTree value
    else
      @left.insert value

  insertRight: (value) ->
    if not @right
      @right = new BinarySearchTree value
    else
      @right.insert value

  each: (fn) ->
    @left.each(fn)  if @left
    fn.call @, @data
    @right.each(fn) if @right

