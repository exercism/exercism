Array::accumulate = (accumulator) ->
  return this.map(accumulator) if typeof Array::map is 'function'
  accumulator i for i in this
