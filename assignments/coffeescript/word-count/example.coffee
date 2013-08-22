class Words
  constructor: (input) ->
    input = input.toLowerCase()
    words = input.match(/\b[a-z0-9]+\b/g)
    counts = {}

    for word in words
      counts[word] = 0 unless counts[word]?
      counts[word] += 1

      @count = counts
  module.exports = @
