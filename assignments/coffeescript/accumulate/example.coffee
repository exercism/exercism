Array.prototype.accumulate = (accumulator) ->
  return this.map(accumulator) if typeof Array.prototype.map == 'function';
  accumulator i for i in this
