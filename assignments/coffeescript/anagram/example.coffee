class Anagram
  constructor: (source) ->
    @source = standard_form(source)

  match: (targets) ->
    target for target in targets when @source is standard_form target

standard_form = (word) ->
  word.toLowerCase().split("").sort().join()

module.exports = Anagram
